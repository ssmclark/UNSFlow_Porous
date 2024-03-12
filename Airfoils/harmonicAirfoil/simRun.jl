push!(LOAD_PATH,"C:\\Users\\user\\ENG_Project_4\\UNSFlow_Porous\\UnsteadyFlowSolvers.jl\\src\\")

using UnsteadyFlowSolvers
using PlotlyJS

alphadef = SinDef(0., 0.05, 0.5, 0.)
hdef = ConstDef(0.)
udef = ConstDef(1.)
full_kinem = KinemDef(alphadef, hdef, udef)
#pitching about the leading edge 
pvt = 0.
geometry = "FlatPlate"
# currently in impermeable limit for flow resistance
surf = TwoDSurfPorous(geometry, pvt, full_kinem, [100.0], rho = 0.02, rho_e = 1.2, phi = 100000)

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

layout = Layout(
    title ="Magnitude of unsteady pressure distribution on a partially porous aerofoil undergoing pitching motion. Flow resistance is $(surf.phi)",
    xaxis_title = "x",
    yaxis_title = "Pressure jump"
)

plot(surf.x, p_com, layout)