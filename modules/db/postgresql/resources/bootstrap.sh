#!/bin/bash

yum update -y
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on

sudo mkdir /postgresql-init

sudo cat << EOF > /postgresql-init/01_init.sql
create table TBL_GROUPS
(
    id   numeric primary key,
    name varchar(256) unique
);

insert into TBL_GROUPS (id, name)
values (1, 'app_admin');
insert into TBL_GROUPS (id, name)
values (2, 'app_user');

commit;


create table TBL_ROLES
(
    id  numeric primary key,
    name varchar(256) unique
);

insert into TBL_ROLES (id, name)
values (1, 'ADMIN');
insert into TBL_ROLES (id, name)
values (2, 'USER');
insert into TBL_ROLES (id, name)
values (3, 'SECRET');

commit;


create table TBL_GROUPS_ROLES
(
    id numeric primary key,
    group_id numeric,
    role_id numeric,
    unique (group_id, role_id)
);

insert into TBL_GROUPS_ROLES(id, group_id, role_id) VALUES (1, 1, 1);
insert into TBL_GROUPS_ROLES(id, group_id, role_id) VALUES (2, 1, 3);

insert into TBL_GROUPS_ROLES(id, group_id, role_id) VALUES (3, 2, 2);

commit;

EOF

# Not best idea but I am lazy. Do not try this at home!
chmod --recursive --silent 777 /postgresql-init

docker run \
    -p ${port}:5432 \
    --env POSTGRES_PASSWORD=${pass} \
    --volume /postgresql-init:/docker-entrypoint-initdb.d \
    postgres
