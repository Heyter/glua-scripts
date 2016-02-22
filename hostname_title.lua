local slogans = [[
Yes, I do change randomly
plz unban me
stop caps ass wholl fuck you caps unban me
u are my friend plis let me be unbaned
plis litening i just wanana be unbane dplis
all this from my boy harth so plis unbane me
is he unban cuz i gotta go to bed can you unb
un bannnnn mmmmmmmmmmmmmmmeeeeeeeeeeeeeeeeee
i am in a ban bubble for no resson
you not un ban me fine i will mack my server
Luckily the ban command wasn't working
your steam ackont will get a perminnit ban
fine get your steam ackont band
and stop with the ban jokes
IM NEVER COME IN YOUR SERVER
AND YOU IGNORE ME ALL TIME YOU RUN AWAY!!!!!!
Its dangerous play one game all days
all you do is play gmod get a life
You never left the lobby?
What am i supposed to do?
press v?
<garry :D> you guys are crazy wtf
Please why do u need to abuse powers on me
I love server please add me to admin pleasse
and i tough you are cool....
ok maybe we kent be no longer friends
BECAUS U STUPIDOS REMOVED MY DEVELOPERRRRRR
this server scares me
sorry, something funny with server
If my mom comes here, im screwed
y is dis server a massive clusterfuck
i guess this server doesnt have hl2 mounted
i dont really what's the point of this server
why does this server change name everytime?
i kno wwhat lua is some thing u ken rihgthe
attempt to index field 'hostname' (a nil valu
lua/hostname.lua:8: assertion failed!
'end' expected (to close 'if' at line 48) nea
I KNOW YOU HATE ME IM DONT HATE YOU YOU DONT
you need to play sports or get a girlfriend
get this shit thing off my screen npw you fuc
ur server is a piece of shit and so are you
make me pls owner can i owner ? Say yes or no
Srsly your admin sucks atm they are minging
that isnt garry i know where garry is pklayig
awww i want to be admin :((( i have exp
this server ken suck my hairy balls
Hopefully the vphysics has no bugs
how do long i will stay pirate? can i chanage
I don't like this server. It is too confusing
why i dont can spawn addons?
You guys are crashing my broadband
To big and messy map. Sorry guys :(
i russian, dont speak inglich))
peioce ofcrap gary hope he gets raped by pigs
fucck this server
how to small
fuck you v button
look I am not trolling anymore
what do hours do
You talking dev language?
HOW DO I MAKE MORE NO MYSELF DRUNK
noob u want ddos? u better no ban noob ;)
PythAdmin: why am i called pythadmin
Did he think he was wallhack?
PROP EXPLODE NOOB. FUCK YOU.
fuck it im done, fuck this server
hello humens.
ooh money%%100.101=10000
anglish man
some ones kill me and i cant kill thouse
UR UR STUPID THEN IF U CANT chad wardeen STEE
baby baby baby oooh like
i cannot do nigga lyrics
which shit admin is kicking me without reason
leaving this shit server
wtf how can you grab me you arent admin
you have 80 hrs and you dont even have a pac!
can we not whack off to satan porn
Viewer Discretion Is Advised
maybe u can play something else than gmodde1
pbton i code parl rudy lue so make me devv2
OMG THERE WAS A BLUE SCREEN
it shows an error picture HOLLYSH HITHIT
¯\_(ツ)_/¯
omg lag i think he ddoing it
IM THE MAKER OF GMOD STOP OR ILL BAN HOLE SVR
ANYBODY PLEASE HELP ARE YOU AACTUALLY DEVELOP
BCZ I DONT SEE ANYONE HELPING SRSLY PEOPEL>>
pls dont DDOS MY FPS i have much to suk :c
You don't even see mah pac
i joined at the rong time
Why do you guys talk in LUA?
guys i'm just gay
i cant remember the last time i had a shower
i thought devs are for helping
The model on the moon is a bit glitchy
fuck off, u need lose ur develoment asshole
Why the server is full lagged?
cant u see hes using my naem the real ahcker
WHATS THIS OGG VIDEO THING THAT KEEPS PLAYING
THIS SERVER IS GOING TO DIE SOON.
wait you can trow in this game?
i thought devs are for helping
I'm head admin y'all cant do shit
No clip the damn wall.
#1 is being ridden by a jockey
might be your age, but something is wrong
do you know what a ddos is?
were can i download all the server addons
developers can make themselves owner
I always plan awesome pacs/outfits
Guys, someone infected my addons folder
HOW DOES GLASS BREK
iTS PORBABLY MY MASSIZE DICK
i dont undenterd you
how do u carate your charecter
what is lua can i dowload it
I morder stupd idiot ho not test Gmod torrent
i blow her home and rip hes ass >((
STOOPPPPP ITS FRSING MY ITMAS
HOW TO DOWNLOAD PORTAL ADDON?
WHY DOES PAC MESS UP ONLINE SERVERS!!!!!!!!!!
DONT PUS HME OR VAC BANN
how i play terrorist town?
get some professional here to crash the serve
this server has always bin ffucking shit
<God> i didnt read all that, religions boring
Source 1.5 runs 48 bit?
WHAT THE FUCK IS THIS SERVER
IM NOT DO IT A ADMIN DO IT
how i quickscope?
stuped humans
Go fuck himself
In your countries propaganda
pls give me admin flex
yes but you are in good mode not funny...
people still use pac?
i quite enjoy the chinese cartoon
this server is pointless and shit goodbye
can i ask u? What we do on this server ?
ok then im getting capsadmin
how do i join the irc to call flex a faggot?
my brother snook on and abused cmds pls unban
I thought that this was TTT
I was exterminating the jews. Be right there
WHY THE HELL DO I HAVE A BLACK GUY ON ME
WHY DOES THIS SERVER HABE NO LUAPAD
we have a world 5 now?
anybody know where i can get a lot of packs?
is this elevator going to stop at every floor
dude your crashing my network
Cant wait get home an be useless shit on Meta
The Avali Homeworld
COME TO ME I THINK I STOPPED THE TIME IN HELL
building the other end of the universe
Satan: these fucking npcs are all on my dick
HOW DO I MAK INTERNET
IM GETTING STALKED BY A FUCKING NAKED WHORE
How can we play fnaf here !!??
HOW CAN WE PLAY GAMES PLS ANSWER
Plz some dev make night on !goto build
Hey, i turned bandicam ? WTF ?
omg help abuser
this server is still just as autistic
Is this server under development?
were can i get pre made pacs on steam
// hOW DO I GET POINTS?
WHO IS NAMING THE SERVER
I have 30 Hour and cant use DUPES WTF
this server sucks no advdupe 2 im leaving
hello im new here how can i get a job
]]
---------------------------------------------
-- ^ This line is how long a text can be in the list!!!!!!!!

slogans = string.Explode ("\n", slogans)

do -- cleanup
	local _slogans = {}
	for _, text in next, slogans do
		local slogan = text:Trim()

		if slogan:len() > 1 then
			table.insert (_slogans, slogan)
		end
	end
	slogans = _slogans
end

timer.Create("SloganTitle",10,0,function() me:SetCustomTitle(table.Random(slogans)) end)

hook.Add("PlayerSay","SloganChat",function(ply,text)
	if text:match"^!slogan" then
		Say(table.Random(slogans))
	end
end)
