# Gillbus

Gillbus IDS "online2" API wrapper

## Installation

Add this line to your application's Gemfile:

    gem 'gillbus'

## Public API

We're trying hard not to raise exceptions.
Each call to Gillbus instance returns response object, which responds to #error?
if #error? is true, you can use #error_message and #error_code
for exact details

## Workflow

* login (sessionLogin/online)
* /online2/getCountries
* /online2/getCities
* /online2/searchTrips
* /online2/getTrips
* /online2/getTripSeats
* /online2/lockSeats
* /online2/ticketsBooking
* /online2/buyTickets
* /online2/getOrderTicket
* /online2/logout

## Quoting API documentation

* Entering the system
  /online2/login/online/
  User authorization
  skipped as obsolete

* Entering the system (second way)
  online2/sessionLogin/online/
  User authorization

* Get trips’ schedule
  /online2/getTimeTable
  Returns trips schedule

* Get country list
  /online2/getCountries
  Returns available countries’ list

* Get available  localities’ list
  /online2/getCities
  Returns available localities’ list

* Get available departure dates’ list
  /online2/getDates
  Returns available departure dates’ list

* Get parameterized trips’ list
  /online2/searchTrips
  Returns parameterized trips’ list

* Get trips’ list
  /online2/getTrips
  Returns trips’ list

* Get seats' map
  /online2/getTripSeats
  Returns seats' map of the vehicle

* Locks seats for sale
  /online2/lockSeats
  Locks seats for sale

* Unlocks seats for sale
  /online2/unlockSeats
  Unlocks seats for sale

* Postponed (unconfirmed) tickets sale
  /online2/bookTickets
  Performs the postponed tickets sale, that waits for the confirmation

* Postponed tickets sale (second way)
  /online2/ticketsBooking
  Performs the postponed tickets sale, that waits for the confirmation

* Sale confirmation
  /online2/buyTickets
  Confirms the earlier postponed tickets sale

* Get the ticket of the order
  /online2/getOrderTicket
  Generates the ticket of the order

* Reserve the ticket
  /online2/reserveTickets
  Makes the ticket reservation

* Reserved tickets’ search
  /online2/findBooking
  Performs parameterized reserved tickets' search

* "Reserved tickets’ search (second way)"
  /online2/findReservation
  Performs parameterized reserved tickets' search

* Buyout the reserved ticket
  /online2/buyBooking
  Buyout the earlier reserved ticket

* #cancel_order Order cancellation
  /online2/cancelOrder
  Cancels the order


* Returns the item, that had been sold
  /online2/returnPosition
  Returns the item, that had been previously sold

* Orders’ search
  /online2/findOrder
  Returns found order's data

* Logout
  /online2/logout
  Closes current session

* Reporting
  /online2/getReport
  Outputs the reports in the Microsoft Excel format

* Get the trips’ list for the date changing
  /online2/getTripsForChange
  Returns the list of trips that are like the assigned trip which has booked ticket, but for the different date.

* Departure date change
  /online2/changeTripDate
  Changes the departure date for the passenger


