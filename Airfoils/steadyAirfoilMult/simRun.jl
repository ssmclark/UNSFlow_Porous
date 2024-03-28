#push!(LOAD_PATH,"path\\to\\UnsteadyFlowSolvers.jl\\src")
push!(LOAD_PATH,"C:\\Users\\user\\ENG_Project_4\\UNSFlow_Porous\\UnsteadyFlowSolvers.jl\\src\\")

using UnsteadyFlowSolvers, PlotlyJS, LaTeXStrings

alphadef = ConstDef(1. *pi/180)

hdef = ConstDef(0.)

udef = ConstDef(1.)

full_kinem = KinemDef(alphadef, hdef, udef)

pvt = 0.2

geometry = "FlatPlate"

#stick function for flow resistance here
# phi = 1/(0.05*(surf.x+1))
# for now use 10000 for impermeable, then 1000, 100, 10, 5, 2, 1, 0.1

surf = TwoDSurfPorous(geometry, pvt, full_kinem, [100.0], rho = 0.02, rho_e = 1.2, phi = 100)
surf2 = TwoDSurfPorous(geometry, pvt, full_kinem, [100.0], rho = 0.02, rho_e = 1.2, phi = 10)
surf3 = TwoDSurfPorous(geometry, pvt, full_kinem, [100.0], rho = 0.02, rho_e = 1.2, phi = 5)
#surf4 = TwoDSurfPorous(geometry, pvt, full_kinem, [100.0], rho = 0.02, rho_e = 1.2, phi = 10)
#surf4 = TwoDSurfPorous(geometry, pvt, full_kinem, [100.0], rho = 0.02, rho_e = 1.2, phi = 5)

curfield= TwoDFlowField()

dtstar = 0.015

t_tot = 5.

nsteps = 1000  #Int(round(t_tot/dtstar))+1

startflag = 0

writeflag = 1

writeInterval = t_tot/5.

#delvort = delSpalart(500, 12, 1e-5)
delvort = delNone()

#issue here with writing to surf and p_out on line 45

mat, surf, curfield, p_out = ldvmLin(surf, curfield, nsteps, dtstar,startflag, writeflag, writeInterval, delvort)
trace = scatter(x=surf.x, y=p_out,
    mode="lines",
    name="Phi= $(surf.phi)")


mat2, surf2, curfield2, p_out2 = ldvmLin(surf2, curfield, nsteps, dtstar,startflag, writeflag, writeInterval, delvort)
trace2 = scatter(x=surf.x, y=p_out2,
     mode="lines",
     name="Phi= $(surf2.phi)")

mat3, surf3, curfield3, p_out3 = ldvmLin(surf3, curfield, nsteps, dtstar,startflag, writeflag, writeInterval, delvort)
trace3 = scatter(x=surf.x, y=p_out3,
        mode="lines",
        name="Phi= $(surf3.phi)")


cleanWrite()
# format this to try to mirror matlab script
layout = Layout(
    title ="Flow Resistance (Phi) for steady aerofoil",
    titlefont_width = 450,
    width = 600, height = 400,
    xaxis_title = "\$x\$",
    yaxis_title = "\$|\\Delta P|\$",
    yaxis_range=[0,5]
)

# possible to add scaling here?


plot([trace,trace2,trace3], layout)