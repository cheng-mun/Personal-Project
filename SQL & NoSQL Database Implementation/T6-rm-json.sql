/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T6-rm-json.sql

--Student ID: 34280332
--Student Name: Chee Cheng Mun


/* Comments for your marker:




*/


-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

select
    json_object(
        '_id' value t.team_id,
                'carn_name' value c.carn_name,
                'carn_date' value to_char(
            c.carn_date,
            'DD-MON-YYYY'
        ),
                'team_name' value t.team_name,
                'team_leader' value
            json_object(
                'name' value comp_leader.comp_fname
                             || ' '
                             || comp_leader.comp_lname,
                        'phone' value comp_leader.comp_phone,
                        'email' value comp_leader.comp_email
            ),
                'team_no_of_members' value team_counts.member_count,
                'team_members' value json_arrayagg(
            json_object(
                'competitor_name' value comp_member.comp_fname
                                        || ' '
                                        || comp_member.comp_lname,
                        'competitor_phone' value comp_member.comp_phone,
                        'event_type' value et.eventtype_desc,
                        'entry_no' value e_member.entry_no,
                        'starttime' value nvl(
                    to_char(
                        e_member.entry_starttime,
                        'HH24:MI:SS'
                    ),
                    '-'
                ),
                        'finishtime' value nvl(
                    to_char(
                        e_member.entry_finishtime,
                        'HH24:MI:SS'
                    ),
                    '-'
                ),
                        'elapsedtime' value nvl(
                    to_char(
                        e_member.entry_elapsedtime,
                        'HH24:MI:SS'
                    ),
                    '-'
                )
            )
        )
    format json)
    || ','
  from team t
  join carnival c
on t.carn_date = c.carn_date
  join entry e_leader
on t.event_id = e_leader.event_id
   and t.entry_no = e_leader.entry_no
  join competitor comp_leader
on e_leader.comp_no = comp_leader.comp_no
  join entry e_member
on t.team_id = e_member.team_id
  join competitor comp_member
on e_member.comp_no = comp_member.comp_no
  join event ev
on e_member.event_id = ev.event_id
  join eventtype et
on ev.eventtype_code = et.eventtype_code
  join (
    select team_id,
           count(*) as member_count
      from entry
     where team_id is not null
     group by team_id
) team_counts
on t.team_id = team_counts.team_id
 group by t.team_id,
          c.carn_name,
          c.carn_date,
          t.team_name,
          comp_leader.comp_fname,
          comp_leader.comp_lname,
          comp_leader.comp_phone,
          comp_leader.comp_email,
          team_counts.member_count
 order by t.team_id;