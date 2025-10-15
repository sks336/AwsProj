###Kafka Commands


    export BROKERS=kafka-0.techlearning.me:9094,kafka-1.techlearning.me:9094,kafka-2.techlearning.me:9094

#### Producer:
    $KAFKA_HOME/bin/kafka-console-producer.sh --broker-list $BROKERS --topic t1

#### Consumer:
    $KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server $BROKERS --topic t1 --from-beginning

