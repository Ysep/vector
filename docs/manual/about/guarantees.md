---
title: Guarantees
description: Vector's gaurantees. Covering delivery and reliability guarantees for each Vector component.
---

Faults in distributed systems are like green Skittles, we all wish they'd never
happen but in reality the best we can do is understand and control the damage
they cause. In event streaming pipelines that means understanding delivery
and stability guarantees and their implications on your overall system.

Vector attempts to make it clear which guarantees you can expect from it. We
categorize all components by their targeted delivery guarantee and also by
their general stability. This helps you make the appropriate trade-offs for your
use case.

Here you can find an overview of delivery guarantee types and their meaning as
well as how we label the stability of our components. Next, you can head over to
the [components page][pages.components] and use filters to see which components
support specific guarantees.

## Delivery Guarantees

<ul class="connected-list">
<li>

### At-Least-Once

The `at-least-once` delivery guarantee ensures that an
[event][docs.data-model] received by Vector will be delivered at least
once to the configured destination(s). While rare, it is possible for an event
to be delivered more than once. See the [Does Vector support exactly once
delivery](#does-vector-support-exactly-once-delivery) FAQ below).

<Alert type="warning">

In order to achieve at least once delivery between restarts your source must
be configured to use `disk` based buffers:

```toml title="vector.toml"
[sinks.my_sink_id]
  # ...

  [sinks.my_sink_id.buffer]
    type = "disk"
    when_full = "block"
    max_size = 104900000 # 100MiB
```

Refer to each [sink's][docs.sinks] documentation for further guidance on its
buffer options.

</Alert>
<Jump to="/components/?at-least-once=true">View all at-least-once components</Jump>
</li>
<li>

### Best-Effort

A `best-effort` delivery guarantee means that Vector will make a best effort to
deliver each event, but cannot _guarantee_ delivery. This is usually due to
limitations of the underlying protocol; which are outside the scope of Vector. It's
important to note that while data loss is possible, it is usually rare and
Vector does everything within its control to ensure data is not lost. For more
info, see the
["Do I need at least once delivery?"](#do-i-need-at-least-once-delivery) FAQ.

Note that this is _not_ the same as `at-most-once` delivery, as it is still
possible for Vector to introduce duplicates under extreme circumstances.

</li>
</ul>

## Reliability Guarantee

<ul class="connected-list">
<li>

### Prod-Ready

The `prod-ready` status is a _subjective_ status defined by the Vector team. It is
intended to give you a general idea of a feature's reliability for production
environments. A feature is `prod-ready` if it meets the following criteria:

1. A meaningful amount of users (generally >50) have been using the feature in
   a production environment for sustained periods without issue.
2. The feature has had sufficient time (generally >4 months) to be community
   tested.
3. The feature API is stable and unlikely to change.
4. There are no major [open bugs][urls.vector_bug_issues] for the feature.

<Jump to="/components/?prod-ready=true">View all prod-ready components</Jump>

</li>
<li>

### Beta

The `beta` status means that a feature has not met the criteria outlined in
the [Prod-Ready](#prod-ready) section and therefore should be used with caution
in production environments.

</li>
</ul>

## FAQs

### Do I need at least once delivery?

One of the unique advantages of the metrics and logging use cases is that data is usually
used for diagnostic purposes only. Therefore, losing the occasional event
has little impact on your business. This affords you the opportunity to
provision your pipeline towards performance, simplicity, and cost reduction.
On the other hand, if you're using your data to perform business critical
functions, then data loss is not acceptable and therefore requires "at least
once" delivery.

To clarify, even though a source or sink is marked as "best effort" it does
not mean Vector takes delivery lightly. In fact, once data is within the
boundary of Vector it will not be lost if you've configured on-disk buffers.
Data loss for "best effort" sources and sinks are almost always due to the
limitations of the underlying protocol.

### Does Vector support exactly once delivery?

No, Vector does not support exactly once delivery. There are future plans to
partially support this for sources and sinks that support it, for example Kafka,
but it remains unclear if Vector will ever be able to achieve this.
We recommend [subscribing to our mailing list](https://vector.dev/community),
which will keep you in the loop if this ever changes.

### How can I find components that meet these guarantees?

Head over to the [components section][pages.components] and use the guarantee
filters.

[docs.data-model]: /docs/about/data-model/
[docs.sinks]: /docs/reference/sinks/
[pages.components]: /components/
[urls.vector_bug_issues]: https://github.com/timberio/vector/issues?q=is%3Aopen+is%3Aissue+label%3A%22type%3A+bug%22
