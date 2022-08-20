--Hiền 20200203
--1.Đưa ra tên các cầu thủ thuộc đội Đức
select membername from member where teamid = 'GER';
--2.Đưa ra tên cầu thủ nhỏ hơn 22 tuổi 
select membername from member 
where date_part('year', current_date) - date_part('year', dob) < 22;
--3.Đưa ra các cầu thủ đã bị cấm thi đấu (2 thẻ vàng/1 thẻ đỏ) 
select * from member
where yellowcard >=2 or redcard >= 1;
--4.Độ tuổi trung bình của các đội bóng 
select teamid, avg(date_part('year', current_date) - date_part('year', dob)) as do_tuoi_trung_binh 
from member
group by (teamid);
--5.Danh sách các hậu vệ có 3 bàn thắng trở lên
select * from match_squad ms, member m
where m.memberid = ms.memberid and position = 'Defender'
and totalgoal > 3;
--6.Cầu thủ trẻ (dưới 23 tuổi) ghi nhiều bàn thắng nhất 
select * from member 
where date_part('year', current_date) - date_part('year', dob) < 23
and totalgoal = (select max(totalgoal) from member 
				 where date_part('year', current_date) - date_part('year', dob) < 23);
				 
--7.	Đưa ra giá vé đắt nhất ở sân nào, khán đài nào
select  stadiumname, standid, price from stadium, stand
where stadium.stadiumid = stand.stadiumid
and price = (select max(price) from stand);

-- 8. Đưa ra cầu thủ có nhiều bàn thắng nhất
select * from member 
where totalgoal = (select max(totalgoal) from member );

--9.	Danh sách số bàn thắng của các đội 
select teamid, sum(totalgoal) as so_ban_thang from member
group by (teamid);

--10. Tra cứu vé của khách hàng có tên Mai Thu Hiền 
select * from ticket t, customer c
where t.customerid = c.customerid
and customername = 'Mai Thu Hiền';
2.	Nguyễn Duy Khánh
--Nguyen Duy Khanh
--MSSV 20204992
--Danh sach cac tran dau dien ra luc 2h
select * from match
where (EXTRACT(HOUR FROM time) = '02') and (EXTRACT(MINUTE FROM time) = '00');

--Tong so tien ve thu duoc cua tung tran dau
select match.matchid, sum(price)
from match join ticket on match.matchid = ticket.matchid
	join stand on stand.standid=ticket.standid
group by match.matchid;

--Danh sach so ban thang cua tung cau thu
select memberid, membername, totalgoal as "So ban thang"
from member
order by totalgoal desc;

--Ket qua cac tran dau cua Qatar
select * 
from match_team
where teamid_1 = (select teamid from team where lower(teamname) = 'qatar') or
teamid_2 = (select teamid from team where lower(teamname) = 'qatar');

--Dua ra tran dau co trong tai "Alexandre Boucaut"
select *
from match join referee_match on match.matchid=referee_match.matchid
join referee on referee_match.refereeid=referee.refereeid
where refereename='Alexandre Boucaut';

--dua ra tran dau dien ra vao ngay 2022-12-03
select match.matchid, (select teamname from team where teamid=match_team.teamid_1) as "Doi Bong 1", (select teamname from team where teamid=match_team.teamid_2) as "Doi Bong 2"
from match join match_team on match.matchid=match_team.matchid
where (EXTRACT(YEAR FROM match.time) = '2022') and (EXTRACT(MONTH FROM match.time) = '12') and (EXTRACT(DAY FROM match.time) = '03');

--Dua ra san bong o Doha, Qatar
select * from stadium
where address='Doha, Qatar';

--Dua ra doi co ban thang cao nhat
select teamid, sum(scoreteam)
from ((select teamid_1 as teamid, scoreteam_1 as scoreteam
from match_team)
union
(select teamid_2 as teamid, scoreteam_2 as scoreteam
from match_team)) as bang2
group by (teamid)
order by (sum)
limit 1
;
--Dua ra danh sach cau thu sinh nam 1997
select * from member
where EXTRACT(year FROM dob) = '1997';
--Dem so the do 1 doi cua tran vua roi
select teamid,sum(redcard)
from member
group by teamid;
3.	Nguyễn Hoàng Long
--Đưa ra thông tin cầu thủ có vị trí là thủ môn 
select * from member, match_squad
where member.memberID = match_squad.memberID and position = 'Goalkeeper'
--Trận đấu có nhiều bàn thắng nhất 
--Danh sách các sân vận động có sức chứa từ 40000 trở lên
select stadium.stadiumid, stadiumname, sum(amount)
from stand, stadium
where stand.stadiumid = stadium.stadiumid
group by (stadium.stadiumid)
having sum(amount) >= 40000;
--Danh sách các cầu thủ có sinh nhật vào tháng 5
select * from member
where date_part ('month', dob) = '5'
--Hiển thị lịch thi đấu ở sân abc 
select MatchID, Time, Round, StadiumName from Stadium, Match
where Stadium.StadiumID = Match.StadiumID and StadiumName = 'abc'
--Số lượng khán giả trung bình tới xem các trận đấu 
select avg(count) as "So khan gia trung binh"
from (select  ticket.matchid, count(ticketid)
from ticket, match
where ticket.matchid=match.matchid
group by ticket.matchid) as bang1;
--Đội bóng nhận nhiều thẻ vàng nhất 
select teamid, sum(yellowcard) as so_the_vang from member
group by (teamid)
order by sum(yellowcard) desc
limit 1;
--
select RefereeName from Referee
where Country = 'Argentina' 
--Đưa ra mã thành viên và tên thành viên có số áo 7 
select MemberID, MemberName from Member
where MemberID likes '%07'
--Xếp đội theo số bàn thắng 
select TeamName, sum (TotalGoal) as number_of_goals from Team, Member
where Team.TeamID = Member.MemberID
group by Team.TeamID
