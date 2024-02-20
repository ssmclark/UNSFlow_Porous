push!(LOAD_PATH,"C:\\Users\\user\\ENG_Project_4\\UnsteadyFlowSolvers.jl\\UnsteadyFlowSolvers.jl")

using UnsteadyFlowSolvers
using Plots

alphadef = ConstDef(0. *pi/180)

hdef = ConstDef(0.)

udef = ConstDef(1.)

full_kinem = KinemDef(alphadef, hdef, udef)

pvt = 0.25

geometry = "FlatPlate"

surf = TwoDSurfPorous(geometry, pvt, full_kinem, [100.0], rho = 0.02, rho_e = 1.2, phi = 5.1)
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

#plot(surf_p.x, surf_p.ws)


cleanWrite()
