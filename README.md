# Bluecap

Bluecap is a Redis-backed system for measuring user engagement over time. It
tracks events passed in from external systems, such as when a user creates an
account, logs in or performs some other key action. Bluecap can also track
properties of users like their gender or location.

Systems can then query Bluecap for data on how a group of users engages with
a product over time, e.g.: for users that created an account a month ago, what
percentage of these users have logged into their account since then? How about
the same report, but only for users that are living in Australia?
