--****PLEASE ENTER YOUR DETAILS BELOW****
--T3-rm-dm.sql

--Student ID: 34280332
--Student Name: Chee Cheng Mun

/* Comments for your marker:
To acquire needed information to add the two new competitors, I make use of select statements with where clause.
As Jackson downgraded his run, he no longer participates in the team's event, thus he is removed from the team.
To remove the entry of Keith, the team id in his entry shall be removed so that the team can be disbanded, avoiding
the fk constraint of team and entry.
*/

--(a)
drop sequence competitor_seq;
drop sequence team_seq;
create sequence competitor_seq start with 100 increment by 5;
create sequence team_seq start with 100 increment by 5;


--(b)
insert into competitor values ( competitor_seq.nextval,
                                'Keith',
                                'Rose',
                                'M',
                                to_date('03/FEB/2004','DD/MON/YYYY'),
                                'keith.rose@example.com',
                                'Y',
                                '0422141112' );
commit;

alter table entry disable constraint team_entry_fk;
alter table team disable constraint entry_team_fk;

insert into team values ( team_seq.nextval,
                          'Super Runners',
                          (
                              select carn_date
                                from carnival
                               where upper(carn_name) = 'RM WINTER SERIES CAULFIELD 2025'
                          ),
                          (
                              select event_id
                                from event
                               where to_char(
                                      carn_date,
                                      'DD/MON/YYYY'
                                  ) = to_char(
                                      (
                                          select carn_date
                                            from carnival
                                           where upper(carn_name) = 'RM WINTER SERIES CAULFIELD 2025'
                                      ),
                                      'DD/MON/YYYY'
                                  )
                                 and eventtype_code = (
                                  select eventtype_code
                                    from eventtype
                                   where lower(eventtype_desc) = '10 km run'
                              )
                          ),
                          (
                              select max(entry_no) + 1
                                from entry
                               where event_id = (
                                  select event_id
                                    from event
                                   where to_char(
                                          carn_date,
                                          'DD/MON/YYYY'
                                      ) = to_char(
                                          (
                                              select carn_date
                                                from carnival
                                               where upper(carn_name) = 'RM WINTER SERIES CAULFIELD 2025'
                                          ),
                                          'DD/MON/YYYY'
                                      )
                                     and eventtype_code = (
                                      select eventtype_code
                                        from eventtype
                                       where lower(eventtype_desc) = '10 km run'
                                  )
                              )
                          ) );
commit;


insert into entry values ( (
    select event_id
      from event
     where to_char(
            carn_date,
            'DD/MON/YYYY'
        ) = to_char(
            (
                select carn_date
                  from carnival
                 where upper(carn_name) = 'RM WINTER SERIES CAULFIELD 2025'
            ),
            'DD/MON/YYYY'
        )
       and eventtype_code = (
        select eventtype_code
          from eventtype
         where lower(eventtype_desc) = '10 km run'
    )
),
                           (
                               select max(entry_no) + 1
                                 from entry
                                where event_id = (
                                   select event_id
                                     from event
                                    where to_char(
                                           carn_date,
                                           'DD/MON/YYYY'
                                       ) = to_char(
                                           (
                                               select carn_date
                                                 from carnival
                                                where upper(carn_name) = 'RM WINTER SERIES CAULFIELD 2025'
                                           ),
                                           'DD/MON/YYYY'
                                       )
                                      and eventtype_code = (
                                       select eventtype_code
                                         from eventtype
                                        where lower(eventtype_desc) = '10 km run'
                                   )
                               )
                           ),
                           null,
                           null,
                           null,
                           competitor_seq.currval,
                           team_seq.currval,
                           (
                               select char_id
                                 from charity
                                where upper(char_name) = upper('Salvation Army')
                           ) );
commit;

insert into competitor values ( competitor_seq.nextval,
                                'Jackson',
                                'Bull',
                                'M',
                                to_date('24/AUG/2004','DD/MM/YYYY'),
                                'jackson.bull@example.com',
                                'Y',
                                '0422412524' );
commit;


insert into entry values ( (
    select event_id
      from event
     where to_char(
            carn_date,
            'DD/MON/YYYY'
        ) = to_char(
            (
                select carn_date
                  from carnival
                 where upper(carn_name) = 'RM WINTER SERIES CAULFIELD 2025'
            ),
            'DD/MON/YYYY'
        )
       and eventtype_code = (
        select eventtype_code
          from eventtype
         where lower(eventtype_desc) = '10 km run'
    )
),
                           (
                               select max(entry_no) + 1
                                 from entry
                                where event_id = (
                                   select event_id
                                     from event
                                    where to_char(
                                           carn_date,
                                           'DD/MON/YYYY'
                                       ) = to_char(
                                           (
                                               select carn_date
                                                 from carnival
                                                where upper(carn_name) = 'RM WINTER SERIES CAULFIELD 2025'
                                           ),
                                           'DD/MON/YYYY'
                                       )
                                      and eventtype_code = (
                                       select eventtype_code
                                         from eventtype
                                        where lower(eventtype_desc) = '10 km run'
                                   )
                               )
                           ),
                           null,
                           null,
                           null,
                           competitor_seq.currval,
                           team_seq.currval,
                           (
                               select char_id
                                 from charity
                                where upper(char_name) = 'RSPCA'
                           ) );

alter table team enable constraint entry_team_fk;
alter table entry enable constraint team_entry_fk;
commit;


--(c)

update entry
   set event_id = (
    select event_id
      from event
     where to_char(
            carn_date,
            'DD/MON/YYYY'
        ) = to_char(
            (
                select carn_date
                  from carnival
                 where upper(carn_name) = 'RM WINTER SERIES CAULFIELD 2025'
            ),
            'DD/MON/YYYY'
        )
       and eventtype_code = (
        select eventtype_code
          from eventtype
         where lower(eventtype_desc) = '5 km run'
    )
),
       entry_no = (
           select max(entry_no) + 1
             from entry
            where event_id = (
               select event_id
                 from event
                where to_char(
                       carn_date,
                       'DD/MON/YYYY'
                   ) = to_char(
                       (
                           select carn_date
                             from carnival
                            where upper(carn_name) = 'RM WINTER SERIES CAULFIELD 2025'
                       ),
                       'DD/MON/YYYY'
                   )
                  and eventtype_code = (
                   select eventtype_code
                     from eventtype
                    where lower(eventtype_desc) = '5 km run'
               )
           )
       ),
       char_id = (
           select char_id
             from charity
            where upper(char_name) = upper('Beyond Blue')
       ),
       team_id = null
 where event_id = (
        select event_id
          from entry
         where comp_no = (
            select comp_no
              from competitor
             where upper(comp_fname) = upper('Jackson')
               and upper(comp_lname) = upper('Bull')
        )
    )
   and entry_no = (
    select max(entry_no)
      from entry
     where event_id = (
        select event_id
          from event
         where to_char(
                carn_date,
                'DD/MON/YYYY'
            ) = to_char(
                (
                    select carn_date
                      from carnival
                     where upper(carn_name) = 'RM WINTER SERIES CAULFIELD 2025'
                ),
                'DD/MON/YYYY'
            )
           and eventtype_code = (
            select eventtype_code
              from eventtype
             where lower(eventtype_desc) = '10 km run'
        )
    )
);

commit;


--(d)

update entry
   set
    team_id = null
 where event_id = (
        select event_id
          from entry
         where comp_no = (
            select comp_no
              from competitor
             where upper(comp_fname) = upper('Keith')
               and upper(comp_lname) = upper('Rose')
        )
    )
   and entry_no = (
    select entry_no
      from entry
     where comp_no = (
        select comp_no
          from competitor
         where upper(comp_fname) = upper('Keith')
           and upper(comp_lname) = upper('Rose')
    )
);
commit;

delete from team
 where team_id = (
    select team_id
      from team
     where upper(team_name) = upper('Super Runners')
);
commit;

delete from entry
 where event_id = (
        select event_id
          from entry
         where comp_no = (
            select comp_no
              from competitor
             where upper(comp_fname) = upper('Keith')
               and upper(comp_lname) = upper('Rose')
        )
    )
   and entry_no = (
    select entry_no
      from entry
     where comp_no = (
        select comp_no
          from competitor
         where upper(comp_fname) = upper('Keith')
           and upper(comp_lname) = upper('Rose')
    )
);
commit;

delete from competitor
 where comp_no = (
    select comp_no
      from competitor
     where upper(comp_fname) = upper('Keith')
       and upper(comp_lname) = upper('Rose')
);
commit;