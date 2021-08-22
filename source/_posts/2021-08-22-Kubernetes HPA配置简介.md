---
layout: post
categories: posts
title: HPA入门
Tags: [k8s]
date: August 22, 2021
excerpt: "HPA（Horizontal Pod Autoscaler，Pod水平自动扩缩工作机制）简介"
---

这两天公司部署在k8s上的一个服务突然被异常打爆内存，pod直接OOM，后面处理了异常之后给这个服务加上了HPA，下面记录一下这个过程。

## 什么是HPA？

HPA(Horizontal Pod Autoscaler)：Pod水平自动扩缩工作机制。HPA是Kubernetes提供的一个资源对象。HPA 通过监控分析控制器（如Deployment, RepicaSet or ReplicationController）控制的所有 Pod 的负载变化情况来动态调整 Pod 的副本数量，做到自动扩缩容。

自动扩缩的好处在于，可以根据业务需要的变化来调整服务部署的份数，在闲时做到资源的节约和高效利用，在流量突增时可以自动扩容扛过流量高峰。

![Untitled](/images/hpa.png)

## 配置方式

### 配置过程

下面是一个简单的示例：

编写`nginx.yaml`以创建一个名为`nginx`的`deployment`：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
        resources:
          # You must specify requests for CPU to autoscale
          # based on CPU utilization
          requests:
            cpu: "250m"
```

创建这个Deployment：

```bash
kubectl apply -f nginx.yaml
```

编写HPA配置文件`nginx-multiple.yaml`：

```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: nginx
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nginx
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  - type: Resource
    resource:
      name: memory
      target:
        type: AverageValue
        averageValue: 100Mi
```

应用该HPA：

```bash
kubectl apply -f nginx-multiple.yaml
```

就是这么简单！

### 字段解释

`apiVersion`: kubernetes `autoscaling`的版本。`autoscaling/v1`只支持基于CPU指标的扩缩。 `autoscaling/v2beta2`才引入基于内存和自定义指标的扩缩。

`kind`: HPA

`metadata`: hpa配置本身的name和namespace

`scaleTargetRef`: tells HPA which scalable controller to scale (Deployment, RepicaSet or ReplicationController)

`minReplicas`, `maxReplicas`: 最小、最大份数

`metrics`: 度量指标，根据这个指标来进行扩缩

`metrics.resource.name:` 资源类型，cpu/memory

`metrics.resource.targetAverageUtilization`: 目标资源平均利用率。

## 算法细节

节选自官方文档：

> 从最基本的角度来看，Pod 水平自动扩缩控制器根据当前指标和期望指标来计算扩缩比例。

```bash
期望副本数 = ceil[当前副本数 * (当前指标 / 期望指标)]
```

> 例如，当前度量值为 `200m`，目标设定值为 `100m`，那么由于 `200.0/100.0 == 2.0`， 副本数量将会翻倍。 如果当前指标为 `50m`，副本数量将会减半，因为`50.0/100.0 == 0.5`。 如果计算出的扩缩比例接近 1.0 （根据`--horizontal-pod-autoscaler-tolerance` 参数全局配置的容忍值，默认为 0.1）， 将会放弃本次扩缩。

被标记删除时间戳的Pod和失败的Pod会被忽略；

如果一个Pod无法获取度量值，则会被搁置，只会在最终确定扩缩数量时考虑；

当使用CPU指标来扩缩时，未就绪或最近的度量值采集于就绪状态前的Pod，也会被搁置。

在排除掉被搁置的 Pod 后，扩缩比例就会根据 `currentMetricValue/desiredMetricValue` 计算出来。

如果创建 HorizontalPodAutoscaler 时指定了多个指标， 那么会按照每个指标分别计算扩缩副本数，取最大值进行扩缩。 如果任何一个指标无法顺利地计算出扩缩副本数（比如，通过 API 获取指标时出错）， 并且可获取的指标建议缩容，那么本次扩缩会被跳过。 这表示，如果一个或多个指标给出的 `desiredReplicas` 值大于当前值，HPA 仍然能实现扩容。

