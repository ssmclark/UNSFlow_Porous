#push!(LOAD_PATH,"path\\to\\UnsteadyFlowSolvers.jl\\src")
push!(LOAD_PATH,"C:\\Users\\user\\ENG_Project_4\\UNSFlow_Porous\\UnsteadyFlowSolvers.jl\\src\\")

using UnsteadyFlowSolvers
using PlotlyJS

alphadef = ConstDef(1. *pi/180)

hdef = ConstDef(0.)

udef = ConstDef(1.)

full_kinem = KinemDef(alphadef, hdef, udef)

pvt = 0.2

geometry = "FlatPlate"
# value for rho_e needs to be changed here. might require another function somewhere
# high values of flow resistance gives impermeable aerofoil
# value for reduced frequency?
surf = TwoDSurfPorous(geometry, pvt, full_kinem, [100.0], rho = 0.02, rho_e = 1.2, phi = 10000000)
surf2 = TwoDSurf(geometry, pvt, full_kinem, [100.0], rho = 0.02)

curfield = TwoDFlowField()

dtstar = 0.015

t_tot = 5.

nsteps = 1000  #Int(round(t_tot/dtstar))+1

startflag = 0

writeflag = 1

writeInterval = t_tot/5.

#delvort = delSpalart(500, 12, 1e-5)
delvort = delNone()

mat, surf, curfield, p_com = ldvmLin(surf, curfield, nsteps, dtstar,startflag, writeflag, writeInterval, delvort)

cleanWrite()

plot(surf.x, p_com)