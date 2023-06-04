// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract EventContract{
    struct Event{
        address organizer; // Person Address Your Organize the Event
        string name;    // Name of Event
        uint date;  // Date of an Event
        uint price; // Price of Ticket for this Event
        uint ticketCount;   // No of Tickets for this Event
        uint ticketRemain;
    }
    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint))public tickets;
    uint public nextId;

    function createEvent(string memory name, uint date, uint price,uint ticketCount) external {
        require(date>block.timestamp,"You Can Organize event for future date");
        require(ticketCount>0,"You Can create event only if you can create more than 0 tickets");
        events[nextId]= Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }
    function buyTikcet(uint id,uint quatity) external payable 
    {
        require(events[id].date!=0,"This Event Does Not Exist");
        require(events[id].date>block.timestamp,"EVent has already Occured");
        Event storage _event= events[id];
        require(msg.value==(_event.price*quatity),"Ethers is not Enough");
        require(_event.ticketRemain>quatity,"Not Enough Tickets remaining");
        _event.ticketRemain-=quatity;
        tickets[msg.sender][id]+=quatity;
    }
    function transferTicket(uint eventId,uint quantity, address transferTo) external {
        require(events[eventId].date!=0,"This Event Does Not Exist");
        require(events[eventId].date>block.timestamp,"EVent has already Occured");
        require(tickets[msg.sender][eventId]>=quantity,"You do NOT have enough Tickets");
        tickets[msg.sender][eventId]-=quantity;
        tickets[transferTo][eventId]+=quantity;
    }
}