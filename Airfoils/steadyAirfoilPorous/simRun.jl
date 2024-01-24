push!(LOAD_PATH,"ssmclark/UNSFlow_Porous/UnsteadyFlowSolvers.jl")

using UnsteadyFlowSolvers

alphadef = ConstDef(5. *pi/180)

hdef = ConstDef(5.)

udef = ConstDef(1.)

full_kinem = KinemDef(alphadef, hdef, udef)

pvt = 0.25

geometry = "FlatPlate"
surf = TwoDSurfPorous(geometry, pvt, full_kinem, rho = 0.02, rho_e = 0, psi = 0)

curfield = TwoDFlowField()

dtstar = find_tstep(alphadef)

t_tot = 10.

nsteps = Int(round(t_tot/dtstar))+1

startflag = 0

writeflag = 1

writeInterval = t_tot/10.