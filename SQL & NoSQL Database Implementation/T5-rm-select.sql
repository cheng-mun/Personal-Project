/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T5-rm-select.sql

--Student ID: 34280332
--Student Name: Chee Cheng Mun


/* Comments for your marker:
The report are written on the date 6/6/2025.



*/


/* (a) */
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

select t.team_name,
       to_char(
           t.carn_date,
           'DD-MON-YYYY'
       ) as carnival_date,
       leader.comp_fname
       || ' '
       || leader.comp_lname as teamleader,
       count(e.comp_no) as team_no_members
  from team t
  join entry e
on t.team_id = e.team_id
  join entry e_leader
on t.event_id = e_leader.event_id
   and t.entry_no = e_leader.entry_no
  join competitor leader
on e_leader.comp_no = leader.comp_no
 where t.team_name in (
    select team_name
      from (
        select team_name,
               count(*) as usage_count
          from team
         group by team_name
    )
     where usage_count = (
        select max(usage_count)
          from (
            select count(*) as usage_count
              from team
             group by team_name
        )
    )
)
   and to_char(
    t.carn_date,
    'DD/MON/YYYY'
) < '6/JUN/2025'
 group by t.team_id,
          t.team_name,
          t.carn_date,
          leader.comp_fname,
          leader.comp_lname
 order by t.team_name,
          t.carn_date;


/* (b) */
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer
-- Report showing record holders for each event type

select et.eventtype_desc as "Event",
       c.carn_name
       || ' held '
       || initcap(to_char(
           c.carn_date,
           'DY'
       ))
       || ' '
       || initcap(to_char(
           c.carn_date,
           'DD-MON-YYYY'
       )) as "Carnival",
       to_char(
           e.entry_elapsedtime,
           'HH24:MI:SS'
       ) as "Current Record",
       comp.comp_no
       || ' '
       || comp.comp_fname
       || ' '
       || comp.comp_lname as "Competitor No and Name",
       to_char(
           (months_between(
               c.carn_date,
               comp.comp_dob
           ) / 12),
           '99'
       ) as "Age at Carnival"
  from entry e
  join event ev
on e.event_id = ev.event_id
  join eventtype et
on ev.eventtype_code = et.eventtype_code
  join carnival c
on ev.carn_date = c.carn_date
  join competitor comp
on e.comp_no = comp.comp_no
 where e.entry_elapsedtime is not null
   and e.entry_elapsedtime = (
    select min(e2.entry_elapsedtime)
      from entry e2
      join event ev2
    on e2.event_id = ev2.event_id
     where ev2.eventtype_code = ev.eventtype_code
       and e2.entry_elapsedtime is not null
)
   and e.comp_no = (
    select min(e3.comp_no)
      from entry e3
      join event ev3
    on e3.event_id = ev3.event_id
     where ev3.eventtype_code = ev.eventtype_code
       and e3.entry_elapsedtime = (
        select min(e4.entry_elapsedtime)
          from entry e4
          join event ev4
        on e4.event_id = ev4.event_id
         where ev4.eventtype_code = ev.eventtype_code
           and e4.entry_elapsedtime is not null
    )
)
 order by et.eventtype_desc,
          comp.comp_no;
          

/* (c) */
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer
-- Report showing entries and percentages for Run Monash carnivals

select ac.carn_name as "Carnival Name",
       initcap(to_char(
           ac.carn_date,
           'DD MON YYYY'
       )) as "Carnival Date",
       ac.eventtype_desc as "Event Description",
       case
           when ee.event_entries is null then
               'Not offered'
           else
               lpad(
                   to_char(ee.event_entries),
                   17
               )
       end as "Number of Entries",
       case
           when ee.event_entries is null then
               ' '
           else
               lpad(
                   to_char(
                       ((ee.event_entries * 100.0) / ct.total_entries),
                       '999'
                   ),
                   21
               )
       end as "% of Carnival Entries"
  from (
    select c.carn_date,
           c.carn_name,
           et.eventtype_desc
      from carnival c
     cross join eventtype et
) ac
  left join (
    select c.carn_date,
           c.carn_name,
           et.eventtype_desc,
           count(e.entry_no) as event_entries
      from carnival c
      join event ev
    on c.carn_date = ev.carn_date
      join eventtype et
    on ev.eventtype_code = et.eventtype_code
      join entry e
    on ev.event_id = e.event_id
     group by c.carn_date,
              c.carn_name,
              et.eventtype_desc
) ee
on ac.carn_date = ee.carn_date
   and ac.carn_name = ee.carn_name
   and ac.eventtype_desc = ee.eventtype_desc
  left join (
    select c.carn_date,
           c.carn_name,
           count(e.entry_no) as total_entries
      from carnival c
      join event ev
    on c.carn_date = ev.carn_date
      join entry e
    on ev.event_id = e.event_id
     group by c.carn_date,
              c.carn_name
) ct
on ac.carn_date = ct.carn_date
   and ac.carn_name = ct.carn_name
 order by ac.carn_date,
          case
              when ee.event_entries is null then
                  - 1
              else
                  ee.event_entries
          end
      desc,
          ac.eventtype_desc;