/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T2-rm-insert.sql

--Student ID: 34280332
--Student Name: Chee Cheng Mun

/* Comments for your marker:
Table team depends on event id and entry no of table entry, while table entry depend on team id of team table.
So, the foreign key of both of these constraints are disabled before the insertion of entry and team tables,
and enabled after the insertion of both tables.
Acknowledging the use of AI
I used AI in the following ways:
(iii) generate some other aspect of the submitted assessment.
I used Microsoft Copilot (https://copilot.microsoft.com/) to assist me with the generation of the data
being inserted in this task. I have manually checked that the data generated aligns with the requirement 
of the task. 
*/

-- Task 2 Load the COMPETITOR, ENTRY and TEAM tables with your own
-- test data following the data requirements expressed in the brief

-- =======================================
-- COMPETITOR
-- =======================================

insert into competitor values ( 1,
                                'Alice',
                                'Tan',
                                'F',
                                to_date('15/MAR/1995','DD/MON/YYYY'),
                                'alice.tan@example.com',
                                'Y',
                                '0123456789' );

insert into competitor values ( 2,
                                'Bob',
                                'Lim',
                                'M',
                                to_date('20/JUN/1992','DD/MON/YYYY'),
                                'bob.lim@example.com',
                                'Y',
                                '0123456790' );

insert into competitor values ( 3,
                                'Charlie',
                                'Ng',
                                'M',
                                to_date('01/JAN/1990','DD/MON/YYYY'),
                                'charlie.ng@example.com',
                                'Y',
                                '0123456791' );

insert into competitor values ( 4,
                                'Diana',
                                'Lee',
                                'F',
                                to_date('12/DEC/1998','DD/MON/YYYY'),
                                'diana.lee@example.com',
                                'Y',
                                '0123456792' );

insert into competitor values ( 5,
                                'Ethan',
                                'Wong',
                                'M',
                                to_date('05/MAY/1997','DD/MON/YYYY'),
                                'ethan.wong@example.com',
                                'Y',
                                '0123456793' );

insert into competitor values ( 6,
                                'Fiona',
                                'Goh',
                                'F',
                                to_date('10/OCT/1988','DD/MON/YYYY'),
                                'fiona.goh@example.com',
                                'N',
                                '0123456794' );

insert into competitor values ( 7,
                                'George',
                                'Chan',
                                'M',
                                to_date('22/JUL/1985','DD/MON/YYYY'),
                                'george.chan@example.com',
                                'N',
                                '0123456795' );

insert into competitor values ( 8,
                                'Hannah',
                                'Teo',
                                'F',
                                to_date('08/AUG/1989','DD/MON/YYYY'),
                                'hannah.teo@example.com',
                                'N',
                                '0123456796' );

insert into competitor values ( 9,
                                'Ivan',
                                'Koh',
                                'M',
                                to_date('30/SEP/1991','DD/MON/YYYY'),
                                'ivan.koh@example.com',
                                'N',
                                '0123456797' );

insert into competitor values ( 10,
                                'Julia',
                                'Lim',
                                'F',
                                to_date('25/APR/1994','DD/MON/YYYY'),
                                'julia.lim@example.com',
                                'N',
                                '0123456798' );

insert into competitor values ( 11,
                                'Kevin',
                                'Liu',
                                'M',
                                to_date('03/NOV/1993','DD/MON/YYYY'),
                                'kevin.liu@example.com',
                                'Y',
                                '0123456799' );

insert into competitor values ( 12,
                                'Linda',
                                'Ong',
                                'F',
                                to_date('17/FEB/1996','DD/MON/YYYY'),
                                'linda.ong@example.com',
                                'Y',
                                '0123456800' );

insert into competitor values ( 13,
                                'Mike',
                                'Tan',
                                'M',
                                to_date('29/MAY/1987','DD/MON/YYYY'),
                                'mike.tan@example.com',
                                'N',
                                '0123456801' );

insert into competitor values ( 14,
                                'Nina',
                                'Lim',
                                'F',
                                to_date('21/AUG/1990','DD/MON/YYYY'),
                                'nina.lim@example.com',
                                'N',
                                '0123456802' );

insert into competitor values ( 15,
                                'Oscar',
                                'Ng',
                                'M',
                                to_date('14/JAN/1992','DD/MON/YYYY'),
                                'oscar.ng@example.com',
                                'Y',
                                '0123456803' );


-- =======================================
-- ENTRY
-- =======================================
alter table entry disable constraint team_entry_fk;
alter table team disable constraint entry_team_fk;

insert into entry values ( 12,
                           1,
                           to_date('08:45:12','hh24:mi:ss'),
                           to_date('09:15:47','hh24:mi:ss'),
                           to_date('00:30:35','hh24:mi:ss'),
                           1,
                           1,
                           null );

insert into entry values ( 12,
                           2,
                           to_date('08:45:08','hh24:mi:ss'),
                           to_date('09:20:21','hh24:mi:ss'),
                           to_date('00:35:13','hh24:mi:ss'),
                           2,
                           null,
                           null );

insert into entry values ( 12,
                           3,
                           to_date('08:50:15','hh24:mi:ss'),
                           to_date('09:30:38','hh24:mi:ss'),
                           to_date('00:40:23','hh24:mi:ss'),
                           3,
                           1,
                           null );

insert into entry values ( 12,
                           4,
                           to_date('08:45:03','hh24:mi:ss'),
                           null,
                           null,
                           4,
                           2,
                           null );

insert into entry values ( 12,
                           5,
                           to_date('08:45:25','hh24:mi:ss'),
                           to_date('09:10:19','hh24:mi:ss'),
                           to_date('00:24:54','hh24:mi:ss'),
                           5,
                           2,
                           null );

insert into entry values ( 13,
                           1,
                           to_date('08:30:18','hh24:mi:ss'),
                           to_date('08:55:33','hh24:mi:ss'),
                           to_date('00:25:15','hh24:mi:ss'),
                           1,
                           null,
                           null );

insert into entry values ( 13,
                           2,
                           to_date('08:35:07','hh24:mi:ss'),
                           to_date('09:10:42','hh24:mi:ss'),
                           to_date('00:35:35','hh24:mi:ss'),
                           6,
                           null,
                           null );

insert into entry values ( 13,
                           3,
                           to_date('08:30:00','hh24:mi:ss'),
                           to_date('09:09:52','hh24:mi:ss'),
                           to_date('00:39:52','hh24:mi:ss'),
                           7,
                           null,
                           null );

insert into entry values ( 13,
                           4,
                           to_date('08:35:00','hh24:mi:ss'),
                           to_date('09:15:17','hh24:mi:ss'),
                           to_date('00:40:17','hh24:mi:ss'),
                           8,
                           3,
                           null );

insert into entry values ( 13,
                           5,
                           to_date('08:40:00','hh24:mi:ss'),
                           null,
                           null,
                           9,
                           null,
                           null );

insert into entry values ( 2,
                           1,
                           to_date('08:30:00','hh24:mi:ss'),
                           to_date('09:00:45','hh24:mi:ss'),
                           to_date('00:30:45','hh24:mi:ss'),
                           10,
                           3,
                           null );

insert into entry values ( 2,
                           2,
                           to_date('08:35:08','hh24:mi:ss'),
                           to_date('09:10:31','hh24:mi:ss'),
                           to_date('00:35:23','hh24:mi:ss'),
                           11,
                           null,
                           null );

insert into entry values ( 2,
                           3,
                           to_date('08:40:25','hh24:mi:ss'),
                           to_date('09:20:13','hh24:mi:ss'),
                           to_date('00:39:48','hh24:mi:ss'),
                           12,
                           null,
                           null );

insert into entry values ( 2,
                           4,
                           to_date('08:44:56','hh24:mi:ss'),
                           to_date('09:25:38','hh24:mi:ss'),
                           to_date('00:40:42','hh24:mi:ss'),
                           1,
                           3,
                           null );

insert into entry values ( 2,
                           5,
                           to_date('08:50:11','hh24:mi:ss'),
                           to_date('09:15:02','hh24:mi:ss'),
                           to_date('00:24:51','hh24:mi:ss'),
                           2,
                           null,
                           null );

insert into entry values ( 2,
                           6,
                           to_date('08:55:17','hh24:mi:ss'),
                           to_date('09:25:10','hh24:mi:ss'),
                           to_date('00:29:53','hh24:mi:ss'),
                           5,
                           null,
                           null );

insert into entry values ( 5,
                           1,
                           to_date('08:00:00','hh24:mi:ss'),
                           to_date('08:30:17','hh24:mi:ss'),
                           to_date('00:30:17','hh24:mi:ss'),
                           3,
                           4,
                           null );

insert into entry values ( 5,
                           2,
                           to_date('08:05:12','hh24:mi:ss'),
                           to_date('08:40:49','hh24:mi:ss'),
                           to_date('00:35:37','hh24:mi:ss'),
                           4,
                           4,
                           null );

insert into entry values ( 5,
                           3,
                           to_date('08:09:55','hh24:mi:ss'),
                           to_date('08:50:23','hh24:mi:ss'),
                           to_date('00:40:28','hh24:mi:ss'),
                           5,
                           null,
                           null );

insert into entry values ( 5,
                           4,
                           to_date('08:15:07','hh24:mi:ss'),
                           to_date('08:54:58','hh24:mi:ss'),
                           to_date('00:39:51','hh24:mi:ss'),
                           6,
                           4,
                           null );

insert into entry values ( 5,
                           5,
                           to_date('08:20:24','hh24:mi:ss'),
                           to_date('08:45:32','hh24:mi:ss'),
                           to_date('00:25:08','hh24:mi:ss'),
                           7,
                           null,
                           null );

insert into entry values ( 14,
                           1,
                           to_date('08:00:00','hh24:mi:ss'),
                           to_date('08:30:16','hh24:mi:ss'),
                           to_date('00:30:16','hh24:mi:ss'),
                           8,
                           5,
                           null );

insert into entry values ( 14,
                           2,
                           to_date('08:05:14','hh24:mi:ss'),
                           to_date('08:40:35','hh24:mi:ss'),
                           to_date('00:35:21','hh24:mi:ss'),
                           9,
                           5,
                           null );

insert into entry values ( 14,
                           3,
                           to_date('08:09:52','hh24:mi:ss'),
                           to_date('08:50:43','hh24:mi:ss'),
                           to_date('00:40:51','hh24:mi:ss'),
                           10,
                           null,
                           null );

insert into entry values ( 14,
                           4,
                           to_date('08:15:06','hh24:mi:ss'),
                           to_date('08:54:59','hh24:mi:ss'),
                           to_date('00:39:53','hh24:mi:ss'),
                           11,
                           5,
                           null );

insert into entry values ( 14,
                           5,
                           to_date('08:20:21','hh24:mi:ss'),
                           to_date('08:45:09','hh24:mi:ss'),
                           to_date('00:24:48','hh24:mi:ss'),
                           12,
                           null,
                           null );

insert into entry values ( 6,
                           1,
                           to_date('08:30:08','hh24:mi:ss'),
                           to_date('09:15:43','hh24:mi:ss'),
                           to_date('00:45:35','hh24:mi:ss'),
                           1,
                           1,
                           1 );

insert into entry values ( 6,
                           2,
                           null,
                           null,
                           null,
                           2,
                           1,
                           2 );

insert into entry values ( 6,
                           3,
                           null,
                           null,
                           null,
                           3,
                           1,
                           3 );

insert into entry values ( 6,
                           4,
                           to_date('08:30:15','hh24:mi:ss'),
                           to_date('09:05:27','hh24:mi:ss'),
                           to_date('00:35:12','hh24:mi:ss'),
                           4,
                           1,
                           1 );

insert into entry values ( 6,
                           5,
                           to_date('08:30:22','hh24:mi:ss'),
                           to_date('09:20:18','hh24:mi:ss'),
                           to_date('00:49:56','hh24:mi:ss'),
                           5,
                           2,
                           2 );

insert into entry values ( 6,
                           6,
                           to_date('08:30:11','hh24:mi:ss'),
                           to_date('09:15:39','hh24:mi:ss'),
                           to_date('00:45:28','hh24:mi:ss'),
                           6,
                           2,
                           3 );

insert into entry values ( 5,
                           6,
                           to_date('08:00:26','hh24:mi:ss'),
                           to_date('08:50:41','hh24:mi:ss'),
                           to_date('00:50:15','hh24:mi:ss'),
                           3,
                           1,
                           null );

insert into entry values ( 6,
                           7,
                           to_date('08:35:14','hh24:mi:ss'),
                           to_date('09:30:37','hh24:mi:ss'),
                           to_date('00:55:23','hh24:mi:ss'),
                           5,
                           2,
                           null );

insert into entry values ( 12,
                           8,
                           to_date('08:45:31','hh24:mi:ss'),
                           to_date('09:25:52','hh24:mi:ss'),
                           to_date('00:40:21','hh24:mi:ss'),
                           6,
                           2,
                           null );

insert into entry values ( 11,
                           1,
                           to_date('07:45:31','hh24:mi:ss'),
                           to_date('10:45:52','hh24:mi:ss'),
                           to_date('03:00:21','hh24:mi:ss'),
                           13,
                           null,
                           null );


-- =======================================
-- TEAM
-- =======================================

insert into team values ( 1,
                          'Coyotes',
                          to_date('22/SEP/2024','DD/MON/YYYY'),
                          12,
                          1 );

insert into team values ( 2,
                          'Wolves',
                          to_date('22/SEP/2024','DD/MON/YYYY'),
                          12,
                          4 );

insert into team values ( 3,
                          'Coyotes',
                          to_date('05/OCT/2024','DD/MON/YYYY'),
                          13,
                          4 );

insert into team values ( 4,
                          'Falcons',
                          to_date('05/OCT/2024','DD/MON/YYYY'),
                          13,
                          1 );

insert into team values ( 5,
                          'Phoenix',
                          to_date('05/OCT/2024','DD/MON/YYYY'),
                          14,
                          1 );

alter table team enable constraint entry_team_fk;
alter table entry enable constraint team_entry_fk;

commit;