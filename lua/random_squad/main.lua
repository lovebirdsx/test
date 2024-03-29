local SQUAD_NAMES = {
	'黄巾-简单-教徒1',
	'黄巾-简单-教徒2',
	'黄巾-简单-教徒3',
	'黄巾-简单-教徒',
	'黄巾-简单-铁兵',
	'黄巾-困难-[B]特法英',
	'黄巾-困难-[B]特法英+强兵',
	'黄巾-困难-[B]铁英+特法英',
	'黄巾-困难-[B]铁英',
	'黄巾-困难-特法英',
	'黄巾-困难-铁兵+法兵',
	'黄巾-困难-铁英',
	'黄巾-普通-法兵',
	'黄巾-普通-教徒',
	'黄巾-普通-强兵',
	'黄巾-普通-特法英',
	'黄巾-普通-铁兵+法兵',
	'黄巾-普通-铁兵+强兵',
	'黄巾-普通-铁英',
	'三国-困难-[B]盾英+教徒',
	'三国-超难-[B]盾英+强英',
	'三国-超难-[B]盾英+特法英',
	'三国-超难-[B]盾英+特铁英',
	'三国-超难-[B]强英+法英',
	'三国-超难-[B]特铁英+特法英',
	'三国-超难-[B]铁英+炼英',
	'三国-超难-炼英+法兵',
	'三国-简单-盾兵',
	'三国-简单-法兵',
	'三国-简单-教徒',
	'三国-简单-炼兵',
	'三国-简单-强兵',
	'三国-简单-铁兵',
	'三国-困难-[B]盾英+法兵',
	'三国-困难-[B]盾英+强兵',
	'三国-困难-[B]强英+盾兵',
	'三国-困难-[B]强英+教徒',
	'三国-困难-[B]特铁英+强兵',
	'三国-困难-盾兵',
	'三国-困难-法英',
	'三国-困难-法英+强兵',
	'三国-困难-法英+铁兵',
	'三国-困难-教徒+炼兵',
	'三国-超难-[B]盾英+强兵',
	'三国-超难-[B]盾英+炼英+法英',
	'三国-超难-[B]铁英+强英',
	'三国-超难-[B]铁英+特法英',
	'三国-超难-[B]铁英+特铁英',
	'三国-困难-[B]盾英+法英',
	'三国-困难-[B]铁英+特强英',
	'三国-困难-盾兵+法兵',
	'三国-超难-[B]盾英+特强英',
	'三国-困难-盾兵+强兵',
	'三国-困难-盾英',
	'三国-困难-盾英+法兵',
	'三国-困难-盾英+强兵',
	'三国-困难-法英+盾兵',
	'三国-困难-炼兵+法兵',
	'三国-困难-炼英',
	'三国-困难-炼英+盾兵',
	'三国-困难-炼英+铁兵',
	'三国-困难-强英',
	'三国-困难-强英+盾兵',
	'三国-困难-强英+教徒',
	'三国-困难-强英+铁兵',
	'三国-困难-特法英+强兵',
	'三国-困难-特法英+铁兵',
	'三国-困难-特强英+盾兵',
	'三国-困难-特强英+教徒',
	'三国-困难-特强英+炼兵',
	'三国-困难-特强英+铁兵',
	'三国-困难-特铁英',
	'三国-困难-特铁英+盾兵',
	'三国-困难-特铁英+法兵',
	'三国-困难-特铁英+强兵',
	'三国-困难-铁兵+法兵',
	'三国-困难-铁英',
	'三国-困难-铁英+强兵',
	'三国-普通-盾兵',
	'三国-普通-盾兵+法兵',
	'三国-普通-盾兵+炼兵',
	'三国-普通-盾兵+强兵',
	'三国-普通-盾兵+铁兵',
	'三国-普通-盾英',
	'三国-普通-法兵',
	'三国-普通-强兵+法兵',
	'三国-普通-教徒',
	'三国-普通-教徒+炼兵',
	'三国-普通-炼兵',
	'三国-普通-强兵',
	'三国-普通-强英',
	'三国-普通-特法英',
	'三国-普通-特强英',
	'三国-普通-特铁英',
	'三国-普通-铁兵',
	'三国-普通-铁兵+法兵',
	'三国-普通-铁兵+强兵',
	'三国-普通-铁英',
	'三国-超难-[B]刺英+法兵',
	'三国-超难-[B]刺英+强兵',
	'三国-超难-[B]刺英+铁兵',
	'三国-超难-[B]盾英+刺英',
	'三国-超难-[B]盾英+刺英+刺英',
	'三国-超难-[B]盾英+盾英+法英',
	'三国-超难-[B]盾英+盾英+炼英',
	'三国-超难-[B]盾英+法英',
	'三国-超难-[B]盾英+法英+法英',
	'三国-超难-[B]盾英+炼兵',
	'三国-超难-[B]盾英+炼英+刺英',
	'三国-超难-[B]盾英+炼英+炼英',
	'三国-超难-[B]盾英+强英+法英',
	'三国-超难-[B]盾英+特炼英',
	'三国-超难-[B]盾英+特铁英+法英',
	'三国-超难-[B]盾英+铁英+刺英',
	'三国-超难-[B]盾英+铁英+强英',
	'三国-超难-[B]盾英+铁英+特法英',
	'三国-超难-[B]法英+教徒',
	'三国-超难-[B]法英+铁兵',
	'三国-超难-[B]炼英+教徒',
	'三国-超难-[B]炼英+炼英',
	'三国-超难-[B]强英+铁兵',
	'三国-超难-[B]特铁英+教徒',
	'三国-超难-[B]特铁英+强兵',
	'三国-超难-[B]特铁英+强英+炼英',
	'三国-超难-[B]铁英+刺英',
	'三国-超难-[B]铁英+法英',
	'三国-超难-[B]铁英+法英+刺英',
	'三国-超难-[B]铁英+法英+法英',
	'三国-超难-[B]铁英+炼兵',
	'三国-超难-[B]铁英+炼英+刺英',
	'三国-超难-[B]铁英+强英+法英',
	'三国-超难-[B]铁英+特炼英',
	'三国-超难-[B]铁英+特炼英+刺英',
	'三国-超难-[B]铁英+特炼英+法英',
	'三国-超难-[B]铁英+特强英',
	'三国-超难-[B]铁英+铁英+强英',
	'三国-超难-刺英+刺英',
	'三国-超难-盾英+法兵',
	'三国-超难-盾英+教徒',
	'三国-超难-盾英+炼兵',
	'三国-超难-盾英+特炼英',
	'三国-超难-法英+铁兵',
	'三国-超难-特法英+盾兵',
	'三国-超难-铁英+法英',
	'三国-超难-铁英+法英+法英',
	'三国-超难-铁英+炼英+炼英',
	'三国-超难-铁英+铁英+法英',
	'三国-简单-刺兵',
	'三国-简单-盾兵+法兵',
	'三国-简单-盾英+教徒',
	'三国-简单-铁兵+法兵',
	'三国-简单-铁兵+强兵',
	'三国-简单-铁英+法兵',
	'三国-简单-铁英+教徒',
	'三国-困难-[B]刺英+盾兵',
	'三国-困难-[B]盾英+刺英+刺英',
	'三国-困难-[B]盾英+炼英',
	'三国-困难-[B]盾英+强英+特炼英',
	'三国-困难-[B]盾英+特炼英',
	'三国-困难-[B]盾英+特强英',
	'三国-困难-[B]盾英+特强英+刺英',
	'三国-困难-[B]盾英+铁英+刺英',
	'三国-困难-[B]法英+铁兵',
	'三国-困难-[B]炼英+炼英',
	'三国-困难-[B]特铁英+刺英',
	'三国-困难-[B]特铁英+炼兵',
	'三国-困难-[B]特铁英+炼英',
	'三国-困难-[B]铁英+强英',
	'三国-困难-[B]铁英+强英+强英',
	'三国-困难-[B]铁英+特强英+法英',
	'三国-困难-刺英+盾兵',
	'三国-困难-刺英+法兵',
	'三国-困难-刺英+教徒',
	'三国-困难-刺英+强兵',
	'三国-困难-刺英+铁兵',
	'三国-困难-盾兵+刺兵',
	'三国-困难-盾兵+铁兵+刺兵',
	'三国-困难-盾兵+铁兵+强兵',
	'三国-困难-盾英+刺英',
	'三国-困难-盾英+盾英',
	'三国-困难-盾英+盾英+刺英',
	'三国-困难-盾英+盾英+法英',
	'三国-困难-盾英+盾英+炼英',
	'三国-困难-盾英+盾英+强英',
	'三国-困难-盾英+盾英+特法英',
	'三国-困难-盾英+法英',
	'三国-困难-盾英+炼英+刺英',
	'三国-困难-盾英+强英',
	'三国-困难-盾英+强英+法英',
	'三国-困难-盾英+强英+炼英',
	'三国-困难-盾英+特法英',
	'三国-困难-盾英+特炼英',
	'三国-困难-盾英+特强英+炼英',
	'三国-困难-盾英+铁英+刺英',
	'三国-困难-盾英+铁英+法英',
	'三国-困难-法兵',
	'三国-困难-法英+法英',
	'三国-困难-法英+教徒',
	'三国-困难-炼英+教徒',
	'三国-困难-炼英+炼英',
	'三国-困难-强兵',
	'三国-困难-强英+强英',
	'三国-困难-盾英+教徒',
	'三国-困难-盾英+炼兵',
	'三国-困难-特法英+盾兵',
	'三国-困难-特法英+教徒',
	'三国-困难-特炼英+盾兵',
	'三国-困难-特炼英+教徒',
	'三国-困难-特炼英+铁兵',
	'三国-困难-特铁英+刺英',
	'三国-困难-特铁英+法英',
	'三国-困难-特铁英+教徒',
	'三国-困难-特铁英+炼兵',
	'三国-困难-特铁英+炼英',
	'三国-困难-特铁英+炼英+刺英',
	'三国-困难-特铁英+强英',
	'三国-困难-特铁英+强英+法英',
	'三国-困难-铁英+特铁英+法英',
	'三国-困难-铁兵',
	'三国-困难-铁兵+刺兵',
	'三国-困难-铁兵+法兵+刺兵',
	'三国-困难-铁兵+炼兵',
	'三国-困难-铁兵+强兵',
	'三国-困难-铁兵+强兵+刺兵',
	'三国-困难-铁兵+强兵+法兵',
	'三国-困难-铁英+刺英',
	'三国-困难-铁英+刺英+刺英',
	'三国-困难-铁英+法兵',
	'三国-困难-铁英+法英',
	'三国-困难-铁英+法英+刺英',
	'三国-困难-铁英+法英+法英',
	'三国-困难-铁英+教徒',
	'三国-困难-铁英+炼兵',
	'三国-困难-铁英+炼英',
	'三国-困难-铁英+炼英+法英',
	'三国-困难-铁英+强英',
	'三国-困难-铁英+强英+法英',
	'三国-困难-铁英+强英+炼英',
	'三国-困难-铁英+强英+强英',
	'三国-困难-铁英+强英+特炼英',
	'三国-困难-铁英+特强英',
	'三国-困难-铁英+铁英',
	'三国-困难-铁英+铁英+刺英',
	'三国-困难-铁英+铁英+法英',
	'三国-困难-铁英+铁英+特法英',
	'三国-困难-铁英+铁英+特炼英',
	'三国-普通-刺兵',
	'三国-普通-刺英+盾兵',
	'三国-普通-刺英+法兵',
	'三国-普通-刺英+教徒',
	'三国-普通-刺英+铁兵',
	'三国-普通-盾兵+刺兵',
	'三国-普通-盾兵+强兵+法兵',
	'三国-普通-盾兵+铁兵+刺兵',
	'三国-普通-盾兵+铁兵+法兵',
	'三国-普通-盾兵+铁兵+强兵',
	'三国-普通-法英+盾兵',
	'三国-普通-法英+教徒',
	'三国-普通-法英+铁兵',
	'三国-普通-炼英+盾兵',
	'三国-普通-炼英+教徒',
	'三国-普通-炼英+铁兵',
	'三国-普通-强英+盾兵',
	'三国-普通-强英+教徒',
	'三国-普通-强英+铁兵',
	'三国-普通-盾英+法兵',
	'三国-普通-盾英+教徒',
	'三国-普通-盾英+炼兵',
	'三国-普通-盾英+强兵',
	'三国-普通-特法英+盾兵',
	'三国-普通-特法英+教徒',
	'三国-普通-特法英+铁兵',
	'三国-普通-特炼英+教徒',
	'三国-普通-特炼英+铁兵',
	'三国-普通-特铁英+法兵',
	'三国-普通-特铁英+教徒',
	'三国-普通-特铁英+炼兵',
	'三国-普通-特铁英+强兵',
	'三国-普通-铁兵+刺兵',
	'三国-普通-铁兵+法兵+刺兵',
	'三国-普通-铁兵+炼兵',
	'三国-普通-铁兵+强兵+刺兵',
	'三国-普通-铁兵+强兵+法兵',
	'三国-普通-铁英+法兵',
	'三国-普通-铁英+教徒',
	'三国-普通-铁英+炼兵',
	'三国-普通-铁英+强兵',
	'三国-超难-盾英+特强英+法英',
	'三国-简单-刺英+盾兵',
	'三国-简单-刺英+法兵',
	'三国-简单-刺英+强兵',
	'三国-简单-刺英+铁兵',
	'三国-简单-盾兵+刺兵',
	'三国-简单-盾兵+炼兵',
	'三国-简单-盾英+法兵',
	'三国-简单-法英+盾兵',
	'三国-简单-法英+教徒',
	'三国-简单-法英+铁兵',
	'三国-简单-炼英+盾兵',
	'三国-简单-炼英+教徒',
	'三国-简单-强英+盾兵',
	'三国-简单-强英+教徒',
	'三国-简单-强英+铁兵',
	'三国-简单-铁兵+刺兵',
	'三国-简单-铁兵+炼兵',
	'三国-简单-铁英+强兵',
	'三国-困难-[B]刺英+刺英',
	'三国-困难-[B]强英+强英',
	'三国-普通-刺英+强兵',
	'三国-困难-[B]刺英+法兵',
	'三国-困难-[B]盾英+强英+强英',
	'三国-困难-盾英+炼英+炼英',
	'三国-困难-盾英+强英+刺英',
	'三国-困难-盾英+强英+强英',
	'三国-困难-盾英+强英+特强英',
	'三国-困难-铁英+特法英+刺英',
	'三国-困难-[B]盾英+强英+法英',
}

function main()
	
end

main()
