# Bluecap

Bluecap is a Redis-backed system for measuring user engagement over time. It
tracks events passed in from external systems, such as when a user creates an
account, logs in or performs some other key action. Bluecap can also track
properties of users like their gender or location.

Systems can then query Bluecap for data on how a group of users engages with
a product over time, e.g.: for users that created an account a month ago, what
percentage of these users have logged into their account since then? How about
the same report, but only for users that are living in Australia?

## Installation

Bluecap requires Ruby 1.9.2 or greater, and Redis 2.5.11 or greater for access
to bitcount and bitop commands. Install the gem by running:

    gem install bluecap

## Usage

Run the server:

    bluecap

By default this will run Bluecap on `0.0.0.0:6088` with Redis on 
`localhost:6379`. Run `bluecap -h` for options.

The server responds to JSON messages received over TCP, the root level key in
the JSON indicates the type of message being sent. Valid message types are:
`identify`, `event`, `attributes` and `report`.

### Identify a user

Send Bluecap a string that uniquely identifies the user in your own system:

    {"identify": "Charlotte"}
    # => 1

    {"identify": {"brian@example.com"}
    # => 2

The server responds with an integer id. When tracking events for the user, the
id is passed along with event data.

### Tracking events

Send the id, name of the event to track, and optionally a UNIX timestamp: 

    {"event": {"id": 1, "name": "Created Account", "timestamp": "1341845456"}}

### Setting user attributes

Send the id and a hash of attributes to set:

    {
      "attributes": {
        "id": 1,
        "attributes": {
          "gender": "Female",
          "country": "Australia"
        }
    }

### Generating a report

The reports generate retention for users over a date range. The report requires
an initial event name to identify cohorts, an event name that measures
engagement, a date range and optional attributes to limit the users contained
in the report:

    {
      "report": {
        "initial_event": "Created Account",
        "engagement_event": "Logged In",
        "attributes": {
          "country": "Australia",
          "gender": "Female"
        },
        "start_date": "20120701",
        "end_date": "20120731",
      }
    }

A report is returned in JSON format showing the engagement over time for each
cohort, e.g.:

    {
      "20120701": {
        "total": 3751,
        "engagement": {
          "20120702": 53.97,
          "20120703": 43.22,
          ...
        },
      },
      "20120702": {
        "total": 4099,
        "engagement": {
          "20120703": 55.81,
          "20120704": 46.73,
          ...
        },
      } 
    }

## Development

Clone the repository and run the tests:

    git clone git://github.com/christopherwright/bluecap.git
    cd bluecap
    rspec

The tests will attempt to create a Redis instance by running `redis-server`.
