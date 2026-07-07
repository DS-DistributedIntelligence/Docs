= Crash Management

== General Information

To crash a replica, it is sufficient to send a `Crash` message to the desired replica. More information on the type of crash will be explained in the following sections, but the check is always the same: if the crash is of the desired type and the number of messages is now set at 0, the `crashNow()` method is invoked. The method stops the heartbeat messages sending task, the heartbeat messages checking task and the synchronization message checking task (if active), to then invoke `getContext().stop(getSelf())`, which effectively and realistically stops the Akka Actor. To avoid error logs by Akka due to the fact that a now no longer active replica is still receiving messages, an `application.conf` file was added to the project containing the `akka.log-dead-letters = 0` and `akka.log-dead-letters-during-shutdown = off` configurations (which make Akka not log messages sent to killed Actors or Actors that are currently being shut down).

== Crash during read and write

To simulate crashes during the update protocol, the enumerator in the `Crash` class is populated with specific types. In particular, they allow a replica to fail:

- after processing an update, namely the unstable write is executed (`Update`);

- after processing a write acknowledgment message (`WriteOK`).

Checks for crashes are set at the end of `performUnstableWrite()` and `performUpdate()` methods respectively, all invoking the `crashNow()` method if they need to crash.

== Crash during coordinator election

To simulate crashes during the election, it is possible to crash the replica:

- after receiving a certain number of heartbeat messages (`Heartbeat`);
- after processing a certain number of election messages (`Election`);
- before sending a synchronization message (`ElectionSync`).

Checks for crashes are set at the start of `checkHeartbeatMsgStatus()`, `onElectionStartedMsg()` and `sendSynchronizationMsg()` methods respectively, all invoking the `crashNow()` method if they need to crash.
