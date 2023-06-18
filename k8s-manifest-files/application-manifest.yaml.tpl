apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: easybuggyapplication
  name: easybuggyapplication-svc
  namespace: easybuggyapplication
spec:
  ports:
  - name: frontend
    port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: easybuggyapplication
  type: NodePort
status:
  loadBalancer: {}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: easybuggyapplication
  name: easybuggyapplication
  namespace: easybuggyapplication
spec:
  replicas: ${APP_REPLICAS}
  selector:
    matchLabels:
      app: easybuggyapplication
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: easybuggyapplication
    spec:
      containers:
      - image: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/easybuggyapplication:${DOCKER_TAG}
        name: easybuggyapplication
        ports:
        - containerPort: 8080
        resources: {}
      imagePullSecrets:
        - name: regcred
status: {}