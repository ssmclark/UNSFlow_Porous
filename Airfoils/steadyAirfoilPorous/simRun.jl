#push!(LOAD_PATH,"path\\to\\UnsteadyFlowSolvers.jl\\src")
push!(LOAD_PATH,"C:\\Users\\user\\ENG_Project_4\\UNSFlow_Porous\\UnsteadyFlowSolvers.jl\\src\\")


using UnsteadyFlowSolvers, PlotlyJS, LaTeXStrings

alphadef = ConstDef(1. *pi/180)

hdef = ConstDef(0.)

udef = ConstDef(1.)

full_kinem = KinemDef(alphadef, hdef, udef)

pvt = 0.

geometry = "FlatPlate"

#stick function for flow resistance here
# phi = 1/(0.05*(surf.x+1))
# for now use 10000 for impermeable, then 1000, 100, 10, 5, 2, 1, 0.1

surf = TwoDSurfPorous(geometry, pvt, full_kinem, [100.0], rho = 0.02, rho_e = 1.2, phi= 0)

curfield= TwoDFlowField()

dtstar = 0.015

t_tot = 5.

nsteps = 1000  #Int(round(t_tot/dtstar))+1

startflag = 0

writeflag = 1

writeInterval = t_tot/5.

#delvort = delSpalart(500, 12, 1e-5)
delvort = delNone()

mat, surf, curfield, p_out = ldvmLin(surf, curfield, nsteps, dtstar,startflag, writeflag, writeInterval, delvort)

cleanWrite()
# 1/(0.75x)
# format this to try to mirror matlab script
layout = Layout(
    title ="Steady aerofoil at Phi = 1/(x)",
    titlefont_width = 450,
    width = 600, height = 400,
    xaxis_title = L"x",
    yaxis_title = L"|\Delta P|",
    #yaxis_range=[0,0.35]
)

plot(surf.x, p_out, layout)
#savePlot=plot(surf.x,p_out, layout)
#savefig(savePlot,"text.html")