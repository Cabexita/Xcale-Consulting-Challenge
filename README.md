# Challenge Xcale Consulting

_Este proyecto se centra en la creacion de un cluster de Kubernetes en AWS (EKS). El servicio es balanceado con ELB (Elastic Load Balancer). El deploy de los pods es realizado a traves de CI/CD con GithubActions_

### Pre-requisitos 📋

_-Cuenta en AWS_
  
    El proyecto corre en la region us-east-1 (N.Virginia)
  
_-Tener instalado AWS CLI_

_-Tener instalado Kubectl_

_-Tener instalado Terraform_

_-Tener instalado Github CLI_

## Comenzando 🚀

_Es necesario realizar las siguientes acciones_

   _-hacer Fork del proyecto_
   
   _-Ir a :gear: **Settings** -> **Secrets** -> **Actions** y agregar las siguientes variables de entorno_
   
    
      AWS_ACCESS_KEY_ID 
      AWS_SECRET_ACCESS_KEY
    
    
   _ejecutando **cat ~/.aws/credentials** va a poder observar la informacion en su consola_
   
### Instalación 🔧

_Inicializar terraform en el directorio /k8-tf/_

```
terraform init
```

_Revisar plan de implementacion_

```
terraform plan
```

_Se crearan 25 recursos_

```
Plan: 25 to add, 0 to change, 0 to destroy.
```

_Aplicar los cambios_

```
terraform apply
o
terraform apply --auto-approve
```

_Aplicar los cambios puede llegar a tomar alrededor de 15 min :timer_clock:_

```
Apply complete! Resources: 25 added, 0 changed, 0 destroyed.
```

_Actualizar nuestro archivo de kubeconfig_

```
aws eks --region us-east-1 update-kubeconfig --name test-eks-cluster
```

_Nos movemos a la carpeta raiz y ejecutamos_

```
gh workflow run
```

_Seleccionamos el workflow Build (kubectl.yml)_


_Luego revisamos la lista de ejecuciones_

```
gh run list --workflow=kubectl.yml
```

_Deberiamos ver el proceso de ejecucion y finalizacion luego de unos 30 sec_



## Ejecutando las pruebas ⚙️

_Revisar el estado de nuestro cluster_

```
aws eks --region us-east-1 describe-cluster --name test-eks-cluster --query cluster.status

"ACTIVE"
```

_Revisar nuestros servicios activos_

```
kubectl get svc

NAME                         TYPE           CLUSTER-IP     EXTERNAL-IP                                                             PORT(S)        AGE
kubernetes                   ClusterIP      172.20.0.1     <none>                                                                  443/TCP        10m
nginx-service-loadbalancer   LoadBalancer   172.20.54.99   a6ebabe01a7014a3a8e7008f25f8df28-41597270.us-east-1.elb.amazonaws.com   80:32424/TCP   111s      
```

_Revisar nodos y pods_

```
kubectl get nodes -o wide

NAME                         STATUS   ROLES    AGE     VERSION                INTERNAL-IP   EXTERNAL-IP   OS-IMAGE         KERNEL-VERSION                 CONTAINER-RUNTIME
ip-10-0-0-163.ec2.internal   Ready    <none>   7m34s   v1.21.14-eks-ba74326   10.0.0.163    <none>        Amazon Linux 2   5.4.209-116.367.amzn2.x86_64   docker://20.10.17
ip-10-0-0-175.ec2.internal   Ready    <none>   6m41s   v1.21.14-eks-ba74326   10.0.0.175    <none>        Amazon Linux 2   5.4.209-116.367.amzn2.x86_64   docker://20.10.17
ip-10-0-0-231.ec2.internal   Ready    <none>   7m17s   v1.21.14-eks-ba74326   10.0.0.231    <none>        Amazon Linux 2   5.4.209-116.367.amzn2.x86_64   docker://20.10.17
ip-10-0-0-244.ec2.internal   Ready    <none>   7m31s   v1.21.14-eks-ba74326   10.0.0.244    <none>        Amazon Linux 2   5.4.209-116.367.amzn2.x86_64   docker://20.10.17

kubectl get pods -o wide 

NAME                                     READY   STATUS    RESTARTS   AGE     IP           NODE                         NOMINATED NODE   READINESS GATES
helloworld-deployment-785dd4874d-rwjgv   1/1     Running   0          5m43s   10.0.0.177   ip-10-0-0-175.ec2.internal   <none>           <none>

```

_Ingresar a la EXTERNAL-IP de nuestro LoadBalancer_

http://<your_external_LoadBalancer_ip>

_y visualizar el servicio funcionando_

## Destruir infraestructura :zap:

_No olvidar de destruir la infraestructura ya que hay servicios que no son gratis y generan gastos_

```
kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl delete -f helloworld-deployment.yml
kubectl delete -f lb.yml

terraform destroy --auto-approve
```
