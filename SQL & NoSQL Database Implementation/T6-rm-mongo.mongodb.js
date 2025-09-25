// *****PLEASE ENTER YOUR DETAILS BELOW*****
// T6-rm-mongo.mongodb.js

// Student ID: 34280332
// Student Name: Chee Cheng Mun

// Comments for your marker:

// ===================================================================================
// DO NOT modify or remove any of the comments below (items marked with //)
// ===================================================================================

// Use (connect to) your database - you MUST update xyz001
// with your authcate username

use("cche0287");

// (b)
// PLEASE PLACE REQUIRED MONGODB COMMAND TO CREATE THE COLLECTION HERE
// YOU MAY PICK ANY COLLECTION NAME
// ENSURE that your query is formatted and has a semicolon
// (;) at the end of this answer

// Drop collection
db.team_member.drop();

// Create collection and insert documents
db.team_member.insertMany([{ "_id": 1, "carn_name": "RM Spring Series Clayton 2024", "carn_date": "22-Sep-2024", "team_name": "Coyotes", "team_leader": { "name": "Alice Tan", "phone": "0123456789", "email": "alice.tan@example.com" }, "team_no_of_members": 7, "team_members": [{ "competitor_name": "Alice Tan", "competitor_phone": "0123456789", "event_type": "5 Km Run", "entry_no": 1, "starttime": "08:45:12", "finishtime": "09:15:47", "elapsedtime": "00:30:35" }, { "competitor_name": "Charlie Ng", "competitor_phone": "0123456791", "event_type": "21.1 Km Half Marathon", "entry_no": 6, "starttime": "08:00:26", "finishtime": "08:50:41", "elapsedtime": "00:50:15" }, { "competitor_name": "Diana Lee", "competitor_phone": "0123456792", "event_type": "3 Km Community Run/Walk", "entry_no": 4, "starttime": "08:30:15", "finishtime": "09:05:27", "elapsedtime": "00:35:12" }, { "competitor_name": "Charlie Ng", "competitor_phone": "0123456791", "event_type": "3 Km Community Run/Walk", "entry_no": 3, "starttime": "-", "finishtime": "-", "elapsedtime": "-" }, { "competitor_name": "Bob Lim", "competitor_phone": "0123456790", "event_type": "3 Km Community Run/Walk", "entry_no": 2, "starttime": "-", "finishtime": "-", "elapsedtime": "-" }, { "competitor_name": "Alice Tan", "competitor_phone": "0123456789", "event_type": "3 Km Community Run/Walk", "entry_no": 1, "starttime": "08:30:08", "finishtime": "09:15:43", "elapsedtime": "00:45:35" }, { "competitor_name": "Charlie Ng", "competitor_phone": "0123456791", "event_type": "5 Km Run", "entry_no": 3, "starttime": "08:50:15", "finishtime": "09:30:38", "elapsedtime": "00:40:23" }] },
{ "_id": 2, "carn_name": "RM Spring Series Clayton 2024", "carn_date": "22-Sep-2024", "team_name": "Wolves", "team_leader": { "name": "Diana Lee", "phone": "0123456792", "email": "diana.lee@example.com" }, "team_no_of_members": 6, "team_members": [{ "competitor_name": "Diana Lee", "competitor_phone": "0123456792", "event_type": "5 Km Run", "entry_no": 4, "starttime": "08:45:03", "finishtime": "-", "elapsedtime": "-" }, { "competitor_name": "Fiona Goh", "competitor_phone": "0123456794", "event_type": "5 Km Run", "entry_no": 8, "starttime": "08:45:31", "finishtime": "09:25:52", "elapsedtime": "00:40:21" }, { "competitor_name": "Ethan Wong", "competitor_phone": "0123456793", "event_type": "3 Km Community Run/Walk", "entry_no": 7, "starttime": "08:35:14", "finishtime": "09:30:37", "elapsedtime": "00:55:23" }, { "competitor_name": "Fiona Goh", "competitor_phone": "0123456794", "event_type": "3 Km Community Run/Walk", "entry_no": 6, "starttime": "08:30:11", "finishtime": "09:15:39", "elapsedtime": "00:45:28" }, { "competitor_name": "Ethan Wong", "competitor_phone": "0123456793", "event_type": "3 Km Community Run/Walk", "entry_no": 5, "starttime": "08:30:22", "finishtime": "09:20:18", "elapsedtime": "00:49:56" }, { "competitor_name": "Ethan Wong", "competitor_phone": "0123456793", "event_type": "5 Km Run", "entry_no": 5, "starttime": "08:45:25", "finishtime": "09:10:19", "elapsedtime": "00:24:54" }] },
{ "_id": 3, "carn_name": "RM Spring Series Caulfield 2024", "carn_date": "05-Oct-2024", "team_name": "Coyotes", "team_leader": { "name": "Hannah Teo", "phone": "0123456796", "email": "hannah.teo@example.com" }, "team_no_of_members": 3, "team_members": [{ "competitor_name": "Hannah Teo", "competitor_phone": "0123456796", "event_type": "10 Km Run", "entry_no": 4, "starttime": "08:35:00", "finishtime": "09:15:17", "elapsedtime": "00:40:17" }, { "competitor_name": "Alice Tan", "competitor_phone": "0123456789", "event_type": "10 Km Run", "entry_no": 4, "starttime": "08:44:56", "finishtime": "09:25:38", "elapsedtime": "00:40:42" }, { "competitor_name": "Julia Lim", "competitor_phone": "0123456798", "event_type": "10 Km Run", "entry_no": 1, "starttime": "08:30:00", "finishtime": "09:00:45", "elapsedtime": "00:30:45" }] },
{ "_id": 4, "carn_name": "RM Spring Series Caulfield 2024", "carn_date": "05-Oct-2024", "team_name": "Falcons", "team_leader": { "name": "Alice Tan", "phone": "0123456789", "email": "alice.tan@example.com" }, "team_no_of_members": 3, "team_members": [{ "competitor_name": "Charlie Ng", "competitor_phone": "0123456791", "event_type": "21.1 Km Half Marathon", "entry_no": 1, "starttime": "08:00:00", "finishtime": "08:30:17", "elapsedtime": "00:30:17" }, { "competitor_name": "Fiona Goh", "competitor_phone": "0123456794", "event_type": "21.1 Km Half Marathon", "entry_no": 4, "starttime": "08:15:07", "finishtime": "08:54:58", "elapsedtime": "00:39:51" }, { "competitor_name": "Diana Lee", "competitor_phone": "0123456792", "event_type": "21.1 Km Half Marathon", "entry_no": 2, "starttime": "08:05:12", "finishtime": "08:40:49", "elapsedtime": "00:35:37" }] },
{ "_id": 5, "carn_name": "RM Spring Series Caulfield 2024", "carn_date": "05-Oct-2024", "team_name": "Phoenix", "team_leader": { "name": "Hannah Teo", "phone": "0123456796", "email": "hannah.teo@example.com" }, "team_no_of_members": 3, "team_members": [{ "competitor_name": "Hannah Teo", "competitor_phone": "0123456796", "event_type": "21.1 Km Half Marathon", "entry_no": 1, "starttime": "08:00:00", "finishtime": "08:30:16", "elapsedtime": "00:30:16" }, { "competitor_name": "Kevin Liu", "competitor_phone": "0123456799", "event_type": "21.1 Km Half Marathon", "entry_no": 4, "starttime": "08:15:06", "finishtime": "08:54:59", "elapsedtime": "00:39:53" }, { "competitor_name": "Ivan Koh", "competitor_phone": "0123456797", "event_type": "21.1 Km Half Marathon", "entry_no": 2, "starttime": "08:05:14", "finishtime": "08:40:35", "elapsedtime": "00:35:21" }] }])


// List all documents you added
db.team_member.find();


// (c)
// PLEASE PLACE REQUIRED MONGODB COMMAND/S FOR THIS PART HERE
// ENSURE that your query is formatted and has a semicolon
// (;) at the end of this answer
db.team_member.find(
    {
        "team_members.event_type": {
            $in: ["5 Km Run", "10 Km Run"]
        }
    },
    {
        "_id": 0,
        "carn_date": 1,
        "carn_name": 1,
        "team_name": 1,
        "team_leader.name": 1
    }
);


// (d)
// PLEASE PLACE REQUIRED MONGODB COMMAND/S FOR THIS PART HERE
// ENSURE that your query is formatted and has a semicolon
// (;) at the end of this answer


// (i) Add new team
// MongoDB command to insert Jackson Bull's new team "The Great Runners"
db.team_member.insertOne({
    "_id": 105,
    "carn_name": "RM WINTER SERIES CAULFIELD 2025",
    "carn_date": "29-Jun-2025",
    "team_name": "The Great Runners",
    "team_leader": {
        "name": "Jackson Bull",
        "phone": "0422412524",
        "email": "jackson.bull@example.com"
    },
    "team_no_of_members": 1,
    "team_members": [
        {
            "competitor_name": "Jackson Bull",
            "competitor_phone": "0422412524",
            "event_type": "5 Km Run",
            "entry_no": 9,
            "starttime": "-",
            "finishtime": "-",
            "elapsedtime": "-"
        }
    ]
});


// Illustrate/confirm changes made
db.team_member.find({ "_id": 105 });
db.team_member.find()

// (ii) Add new team member
db.team_member.updateOne(
    { "_id": 105 },
    {
        $push: {
            "team_members": {
                "competitor_name": "Steve Bull",
                "competitor_phone": "0422251427",
                "event_type": "10 Km Run",
                "entry_no": 10,
                "starttime": "-",
                "finishtime": "-",
                "elapsedtime": "-"
            }
        },
        $set: {
            "team_no_of_members": 2
        }
    }
);


// Illustrate/confirm changes made
db.team_member.find({ "_id": 105 });
db.team_member.find()
