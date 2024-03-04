push!(LOAD_PATH,"C:\\Users\\user\\ENG_Project_4\\UNSFlow_Porous\\UnsteadyFlowSolvers.jl\\src\\")

using UnsteadyFlowSolvers

alphadef = ConstDef(5. *pi/180)

hdef = ConstDef(5.)

udef = ConstDef(1.)

full_kinem = KinemDef(alphadef, hdef, udef)

pvt = 0.25

geometry = "FlatPlate"

surf = TwoDSurf(geometry, pvt, full_kinem, rho = 0.02)

curfield = TwoDFlowField()

dtstar = find_tstep(alphadef)

t_tot = 10.

nsteps = Int(round(t_tot/dtstar))+1

startflag = 0

writeflag = 1

writeInterval = t_tot/10.

#delvort = delSpalart(500, 12, 1e-5)
delvort = delNone()

mat, surf, curfield = lautat(surf, curfield, nsteps, dtstar,startflag, writeflag, writeInterval, delvort, wakerollup=1)

makeForcePlots2D()

makeVortPlots2D()

cleanWrite()
