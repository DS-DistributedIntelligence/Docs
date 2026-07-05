= Read and write management

As requirement of the project, reads must be locally performed, while writes have to be approved by the majority, and only then the coordinator can proceed to apply and broadcast the change. The database is a map of `<idx: Integer, value: Integer>`, and each replica affects only its own database.

// TODO: assumption (quorum always available, mesages to ourselves use akka .tell, client timeout counter)

== Read request

A client may ask to a replica to read a value in the database associated to an index. Hence, the client sends the request and set a timeout in order to detect the replica failure. If no result is provided before the timeout expiration, the replica is consider crashed and the relative callback is invoked. Once the replica receives the request, it immediately reads the database and send back the result.

== Write request

A client may ask to a replica to write a value into the database, providing the index and the new value. Similarly to the read request, the client sets a timeout to detect the replica crash. Note that this timeout has to be larger because of the non-local procedure, unlike reads. The timeout, indeed, is significantly affected by the estimated latency (in our project `AbstractReplica.MAX_LATENCY` is adopted) and the number of initial replicas.

Each replica stores a queue of `<client: ActorRef, request: WriteRequest>` pairs. These are the list of unstable requests that are waiting to be processed by the coordinator and sent back to the respective client. After pushing the request into the queue, a `WriteRequestToCoordinator` message is sent to the leader. The latter has a queue of `<request: WriteRequesToCoordinator>` which is the ordered list of unstable writes. As a request arrives, the coordinator pushes it into the queue and always processes the first one by a `.poll()` function. This operation is important to preserve *sequential consistency*. /*To keep our implementation simple but still effective*/ Our implementation lets the coordinator to process one write at a time: a write is taken in charge, a `WriteNotification` message is broadcasted waiting for the relative acknowledgments, the write is stabilized after receiving ACKs from the majority, and finally the `WriteOK` message is sent to all replicas such that all of them can perform the write. Moreover, the replica that receives a `WriteOK` for a request in its queue, sends the result back to the relative client and pops out the element from the list. The most relevant aspects of this protocol are described in the following sections.

=== Write notification acknowledgments

After a write notification broadcast, a timeout is set for every replica in order to detect eventual failures. A `pendingAcks<replicaId: Integer>` list is populated with the IDs of all the replicas but the coordinator. When an ACK is received, the ID of the corresponding replica is removed from the list, and when the timeout expires the replicas with the IDs contained in `pendingAcks` are considered crashed (no ACKs received). Each timeout is associated to an incremental counter called `acksRound`. This is useful because, in case the coordinator is able to rapidly process two writes, a stale ACK is not considered (its round is lower than the current one).

=== Replicas failures and quorum update

The quorum is defined as $Q = floor(N / 2) + 1$ where $N$ is the number of active replicas. It needs to be updated when a replica crashes thus, during a write notification, the coordinator waits for all ACKs before processing a new write even though it reached the quorum. If some timeouts expire, the relative replicas are considered crashed and the quorum is updated. These replicas are also removed from the `replicasGroup` that is a local clone of the immutable map passed in the `initSystem()` method.

=== Current write process

The coordinator performs one write at a time. // TODO: when ProcessNextWriteIfAny is called
