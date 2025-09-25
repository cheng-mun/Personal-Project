/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T1-rm-schema.sql

--Student ID: 34280332
--Student Name: Chee Cheng Mun

/* Comments for your marker:




*/

/* drop table statements - do not remove*/

drop table competitor cascade constraints purge;

drop table entry cascade constraints purge;

drop table team cascade constraints purge;

/* end of drop table statements*/

-- Task 1 Add Create table statements for the Missing TABLES below.
-- Ensure all column comments, and constraints (other than FK's)are included.
-- FK constraints are to be added at the end of this script

-- COMPETITOR
create table competitor (
    comp_no        number(5) not null,
    comp_fname     varchar2(30),
    comp_lname     varchar2(30),
    comp_gender    char(1) not null,
    comp_dob       date not null,
    comp_email     varchar2(50) not null,
    comp_unistatus char(1) not null,
    comp_phone     char(10) not null
);

comment on column competitor.comp_no is
    'Unique identifier for a competitor';

comment on column competitor.comp_fname is
    'Competitor''s first name';

comment on column competitor.comp_lname is
    'Competitor''s last name';

comment on column competitor.comp_gender is
    'Competitor''s gender';

comment on column competitor.comp_dob is
    'Competitor''s date of birth';

comment on column competitor.comp_email is
    'Competitor''s email (unique for each competitor)';

comment on column competitor.comp_unistatus is
    'Competitor is a university student or staff';

comment on column competitor.comp_phone is
    'Competitor''s phone number (unique for each competitor)';

alter table competitor add constraint competitor_pk primary key ( comp_no );

alter table competitor add constraint competitor_uq unique ( comp_email,
                                                             comp_phone );

alter table competitor
    add constraint ck_comp_gender
        check ( comp_gender in ( 'M',
                                 'F',
                                 'U' ) );

alter table competitor
    add constraint ck_comp_unistatus check ( comp_unistatus in ( 'Y',
                                                                 'N' ) );

--ENTRY
create table entry (
    event_id          number(6) not null,
    entry_no          number(5) not null,
    entry_starttime   date,
    entry_finishtime  date,
    entry_elapsedtime date,
    comp_no           number(5) not null,
    team_id           number(3),
    char_id           number(3)
);

comment on column entry.event_id is
    'Event id (surrogate primary key)';

comment on column entry.entry_no is
    'Entry number (unique only within an event) ';

comment on column entry.entry_starttime is
    'The entrant''s start time';

comment on column entry.entry_finishtime is
    'The entrant''s finish time';

comment on column entry.entry_elapsedtime is
    'The time the entrant took to complete the event';

comment on column entry.comp_no is
    'Unique identifier for a competitor';

comment on column entry.team_id is
    'Team identifier';

comment on column entry.char_id is
    'Charity unique identifier';

alter table entry add constraint entry_pk primary key ( event_id,
                                                        entry_no );

--TEAM
create table team (
    team_id   number(3) not null,
    team_name varchar2(30) not null,
    carn_date date not null,
    event_id  number(6) not null,
    entry_no  number(5) not null
);

comment on column team.team_id is
    'Team identifier';

comment on column team.team_name is
    'Team name (unique)';

comment on column team.carn_date is
    'Date of carnival (unique identifier)';

comment on column team.event_id is
    'Event id';

comment on column team.entry_no is
    'Entry number';

alter table team add constraint team_pk primary key ( team_id );

alter table team add constraint team_uq unique ( team_name,
                                                 carn_date );

-- Add all missing FK Constraints below here

alter table entry
    add constraint event_entry_fk foreign key ( event_id )
        references event ( event_id );

alter table entry
    add constraint competitor_entry_fk foreign key ( comp_no )
        references competitor ( comp_no );

alter table entry
    add constraint team_entry_fk foreign key ( team_id )
        references team ( team_id );

alter table entry
    add constraint charity_entry_fk foreign key ( char_id )
        references charity ( char_id );

alter table team
    add constraint carnival_team_fk foreign key ( carn_date )
        references carnival ( carn_date );

alter table team
    add constraint entry_team_fk
        foreign key ( event_id,
                      entry_no )
            references entry ( event_id,
                               entry_no );