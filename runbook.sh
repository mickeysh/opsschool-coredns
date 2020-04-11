
# ClusterIP Service
kubectl create -f deployment-1.yaml
kubectl create -f service.yaml

kubectl run --restart=Never -it --image infoblox/dnstools dnstools
dig -t a service-cluser.default.svc.cluster.local

# Headless Service - without hostname/stbdomain
kubectl delete svc service-cluster
kubectl create -f service-headless.yaml
kubectl run --restart=Never -it --image infoblox/dnstools dnstools
dig -t a service-cluser.default.svc.cluster.local
dig -t srv service-cluser.default.svc.cluster.local

# Headless Service - with hostname/stbdomain
kubectl delete deploy headless
kubectl create -f deployment-2.yaml
kubectl run --restart=Never -it --image infoblox/dnstools dnstools
dig -t srv service-cluser.default.svc.cluster.local

# Headless Service - with hostname/stbdomain
kubectl delete deploy headless
kubectl create -f statefulset.yaml
kubectl run --restart=Never -it --image infoblox/dnstools dnstools
dig -t srv service-cluser.default.svc.cluster.local

# wild card queries 
host *.default.svc.cluster.local.
host kube-dns.kube-system.svc.cluster.local.
host *.kube-dns.kube-system.svc.cluster.local.

