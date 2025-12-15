helm repo add lensesio https://helm.repo.lenses.io
helm repo update

helm search repo lenses


kubectl create secret generic lenses-license \
  --from-file=license.json \
  -n ns-kafka


kubectl create configmap lenses-provision \
  --from-file=provision.yaml \
  -n ns-kafka


helm -n ns-kafka install lenses lensesio/lenses -f values.yaml



