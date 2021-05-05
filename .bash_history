exit
ls
cd ..
ls
exit
oc whoami
exit
oc login --token=sha256~EzWBQdTFvPgDkgYwpCo-TiigIqIZj73xVsEyUALsGyg --server=https://api.techlab.openshift.ch:6443
oc version
ls
cd kafka
ls
cd ..
oc new-project <username>-autoscale
oc new-project hannelore9-autoscale
oc new-app openshift/ruby:2.5~https://github.com/chrira/ruby-ex.git#load
oc create route edge --insecure-policy=Allow --service=ruby-ex
sum(node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate{namespace='hannelore9-autoscale'}) by (pod)
oc edit deploy ruby-ex
oc autoscale deploy ruby-ex --min 1 --max 3 --cpu-percent=25
oc get route -o custom-columns=NAME:.metadata.name,HOSTNAME:.spec.host
for i in {1..500}; do curl -s https://ruby-ex-hannelore9-autoscale.techlab.openshift.ch/load ; done;
oc autoscale deploy ruby-ex --min 1 --max 3 --cpu-percent=25
for i in {1..500}; do curl -s https://[HOSTNAME]/load ; done;
for i in {1..500}; do curl -s https://ruby-ex-hannelore9-autoscale.techlab.openshift.ch/load ; done;
echo $LAB_USER
export LAB_USER=<username>
export LAB_USER=hannelore9
oc project $LAB_USER
oc get ServiceAccount
tkn version
mkdir CI_DD
rmdir CI_DD
mkdir CI_CD
cd CI_CD/
vi deploy-task.yaml
oc apply -f deploy-task.yaml
tkn task ls
vi deploy-pipeline.yaml
oc apply -f deploy-pipeline.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
spec:
vi workspaces-pvc.yaml
oc apply -f workspaces-pvc.yaml
vi pipeline-run-template.yaml
oc process -f pipeline-run-template.yaml   --param=PROJECT_NAME=$(oc project -q) | oc apply -f-
tkn pipelinerun logs build-and-deploy-run-1 -f -n $LAB_USER
tkn pipeline start build-and-deploy   -p git-url='https://github.com/puzzle/quarkus-techlab-data-transformer.git'   -p git-revision='master'   -p docker-file='src/main/docker/Dockerfile.binary'   -p image-name="image-registry.openshift-image-registry.svc:5000/$(oc project -q)/data-transformer:latest"   -p manifest-dir='src/main/openshift/templates'   -p deployment-name=data-transformer   -s pipeline   -w name=source-workspace,claimName=pipeline-workspace
tkn pipelinerun logs build-and-deploy-run-t5lcd -f -n hannelore9
tkn pipeline start build-and-deploy   -p git-url='https://github.com/puzzle/quarkus-techlab-data-transformer.git'   -p git-revision='master'   -p docker-file='src/main/docker/Dockerfile.binary'   -p image-name="image-registry.openshift-image-registry.svc:5000/$(oc project -q)/data-transformer:latest"   -p manifest-dir='src/main/openshift/templates'   -p deployment-name=data-transformer   -s pipeline   -w name=source-workspace,claimName=pipeline-workspace
tkn pipelinerun logs build-and-deploy-run-t5lcd -f -n hannelore9
argocd login argocd.techlab.openshift.ch --grpc-web --username hannelore
argocd login argocd.techlab.openshift.ch --grpc-web --username hannelore9
exit
