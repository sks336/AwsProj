###Kafka Commands


    export BROKERS=kafka-0.techlearning.me:9094,kafka-1.techlearning.me:9094,kafka-2.techlearning.me:9094

#### Producer:
    kafka-console-producer.sh --broker-list $BROKERS --topic t1

#### Consumer:
    kafka-console-consumer.sh --bootstrap-server $BROKERS --topic t1 --from-beginning

