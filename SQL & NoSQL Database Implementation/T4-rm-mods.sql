--****PLEASE ENTER YOUR DETAILS BELOW****
--T4-rm-mods.sql

--Student ID: 34280332
--Student Name: Chee Cheng Mun

/* Comments for your marker:
For 4a, competitors who doesn't have elapsed time are considered to have not finished an event.

For 4b, I created a new table charity_percentage to record the information of the funds percentage allocated for
different charity for competitors who contributes to more than one charity.

*/

--(a)
select *
  from competitor;
desc competitor;

alter table competitor add comp_completeev number(2);
desc competitor;

comment on column competitor.comp_completeev is
    'Number of completed events of the Competitor';

update competitor
   set
    comp_completeev = (
        select nvl(
            count(
                case
                    when
                        entry_starttime is not null
                        and entry_finishtime is not null
                        and entry_elapsedtime is not null
                    then
                        1
                end
            ),
            0
        )
          from entry
         where entry.comp_no = competitor.comp_no
    );
commit;
select *
  from competitor;


--(b) 
drop table charity_percentage cascade constraints purge;

create table charity_percentage (
    comp_no       number(5) not null,
    char_id       number(3) not null,
    carn_date     date not null,
    cp_percentage number(3) not null
);

comment on column charity_percentage.comp_no is
    'Unique identifier for a competitor';

comment on column charity_percentage.char_id is
    'Charity unique identifier';

comment on column charity_percentage.carn_date is
    'Date of carnival (unique identifier)';

comment on column charity_percentage.cp_percentage is
    'The percentage (0 to 100) of the total funds that will go to the charity';

alter table charity_percentage
    add constraint pk_charity_percentage primary key ( comp_no,
                                                       char_id,
                                                       carn_date );
alter table charity_percentage
    add constraint fk_cp_comp foreign key ( comp_no )
        references competitor ( comp_no );

alter table charity_percentage
    add constraint fk_cp_charity foreign key ( char_id )
        references charity ( char_id );

alter table charity_percentage
    add constraint fk_cp_carnival foreign key ( carn_date )
        references carnival ( carn_date );

alter table charity_percentage
    add constraint ck_cp_percentage check ( cp_percentage between 0 and 100 );

commit;

select *
  from charity_percentage;
desc charity_percentage;