use test
select "<info_to_display>" as "" ;

drop table if exists parent ;
create table parent like user ;
show fields from parent ;

drop table if exists child ;
create table child like user ;
show fields from child ;

drop table if exists sibling ;
create table sibling like user ;
show fields from sibling ;

