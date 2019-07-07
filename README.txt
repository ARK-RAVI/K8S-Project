Task Readme 
 
Deploying a Containerized customized Nginx Application 

 
Objectives:
 
1.	Package Nginx app into a Docker image
2.	Verified container locally 
3.	Push images to Docker registry
4.	Create a Kubernetes cluster 
5.	Deploy Nginx app to the Kubernetes cluster 
6.	Deploy a new version of Nginx
 
 
Step 1: Build a container image
 
I have created a Dockerfile

https://github.com/rkarigela/Risk-Ident/blob/master/Dockerfile

Step 2: Run container Locally
 
To test the container image working locally, run the following command. Here I have created two docker images for v1 and v2

# docker run -dit -p 80:80  ark-nginx:v1
# curl localhost

Step 3: Push images to Docker registry

docker tag ark-nginx:v2 rkarigela/ark-ngix.v1
docker push push rkarigela/ark-ngix.v1


docker tag ark-nginx:v2 rkarigela/ark-ngix.v2
docker push push rkarigela/ark-ngix.v2

https://hub.docker.com/r/rkarigela/ark-ngix.v1
https://hub.docker.com/r/rkarigela/ark-ngix.v2

  Step 4: Create a Kubernetes cluster 
Detailed steps for cluster configuration 

https://github.com/rkarigela/Risk-Ident/blob/master/K8S-Cluster-Configuration-Guide.txt

arigela19@k8s-master:~$ kubectl get nodes
NAME         STATUS   ROLES    AGE     VERSION
k8s-master   Ready    master   7h11m   v1.15.0
k8s-node1    Ready    <none>   7h4m    v1.15.0
k8s-node2    Ready    <none>   7h4m    v1.15.0

Step 5: Deploy nginx v1 app to the Kubernetes cluster

To deploy application run following commands

kubectl create -f nginx-deployment.yaml
kubectl create -f nginx-svc.yaml


https://github.com/rkarigela/Risk-Ident/blob/master/nginx-deployment.yaml

https://github.com/rkarigela/Risk-Ident/blob/master/nginx-svc.yaml

arigela19@k8s-master:~/Risk-Ident$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
my-nginx-7cf8946bbb-hlqmv   1/1     Running   0          46m
my-nginx-7cf8946bbb-k2jnb   1/1     Running   0          46m
my-nginx-7cf8946bbb-kdsfx   1/1     Running   0          46m
arigela19@k8s-master:~/Risk-Ident$ kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
ark-nginx    ClusterIP   10.107.133.170   <none>        80/TCP    59m
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP   7h26m
arigela19@k8s-master:~/Risk-Ident$ kubectl get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
my-nginx   3/3     3            3           43m
arigela19@k8s-master:~/Risk-Ident$ kubectl describe deploy my-nginx |grep -i image
Image:        rkarigela/ark-ngix.v1


arigela19@k8s-master:~$  kubectl exec -it my-nginx-7fb7dcb4c9-h6w4t  -- /bin/bash
[root@my-nginx-7fb7dcb4c9-h6w4t /]# curl localhost
<!DOCTYPE       html>
<html>
<body>
<h1> Hello World! </h1>
</body>
</hml>
[root@my-nginx-7fb7dcb4c9-h6w4t /]#
 
Step 6: Deploy a new version of Nginx (v2)

Kubernetes rolling update mechanism ensures that your application remains up and available even as the system replaces instances of your old container image with your new one across all the running replicas.
 
Please modify the with deployment yaml file to apply the changes. 

arigela19@k8s-master:~/Risk-Ident$ kubectl apply -f nginx-deployment.yaml
arigela19@k8s-master:~/Risk-Ident$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
my-nginx-7cf8946bbb-hlqmv   1/1     Running   0          57m
my-nginx-7cf8946bbb-k2jnb   1/1     Running   0          57m
my-nginx-7cf8946bbb-kdsfx   1/1     Running   0          57m


arigela19@k8s-master:~/Risk-Ident$ kubectl get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
my-nginx   3/3     3            3           56m




arigela19@k8s-master:~/Risk-Ident$ kubectl describe deploy my-nginx | grep -I image
Image:        rkarigela/ark-ngix.v2
 
arigela19@k8s-master:~/Risk-Ident$ kubectl exec -it my-nginx-7cf8946bbb-hlqmv -- /bin/bash
[root@my-nginx-7cf8946bbb-hlqmv /]# curl localhost
<!DOCTYPE       html>
<html>
<body>
<h1> Hello World! </h1>
<h1> I am version 2 </h1>
</body>
</hml>
[root@my-nginx-7cf8946bbb-hlqmv /]#

