push!(LOAD_PATH,"C:/Users/user/ENG_Project_4/UNSFlow_Porous/UnsteadyFlowSolvers.jl/src")

using UnsteadyFlowSolvers, PlotlyJS, LaTeXStrings
cd("C:/Users/user/ENG_Project_4/UNSFlow_Porous/Airfoils/harmonicAirfoilMult/")
m = 0:0.25:1
folderCheck=isdir("FlowResist_0.0/")
if folderCheck == true
    rm("FlowResist_0.0/", force = true, recursive = true)
    rm("FlowResist_0.5/", force = true, recursive = true)
    rm("FlowResist_0.25/", force = true, recursive = true)
    rm("FlowResist_0.75/", force = true, recursive = true)
    rm("FlowResist_1.0/", force = true, recursive = true)
end

x = []
p_arr= []
for j in m 

    mkdir("FlowResist_"*string(j))

    cd("FlowResist_"*string(j))

    alphadef = SinDef(0., 0.5, 0.5, 0.)
    
    hdef = ConstDef(0.)
    udef = ConstDef(1.)
    full_kinem = KinemDef(alphadef, hdef, udef)
    #pitching about the leading edge 
    pvt = 0.
    geometry = "FlatPlate"
    # currently in impermeable limit for flow resistance
    surf = TwoDSurfPorous(geometry, pvt, full_kinem, [100.0], rho = 0.02, rho_e = 1.2, phi = 0, m=j)
    global x = surf.x 
    curfield = TwoDFlowField()
    
    dtstar = 0.015
    
    t_tot = 5.
    
    nsteps = 1000  #Int(round(t_tot/dtstar))+1
    
    startflag = 0
    
    writeflag = 1
    
    writeInterval = t_tot/5.
    
    #delvort = delSpalart(500, 12, 1e-5)
    delvort = delNone()
    
    mat, surf, curfield, p_out = ldvmLin(surf, curfield, nsteps, dtstar,startflag, writeflag, writeInterval, delvort, m=j)
    
    cleanWrite()
    #1/(0.75x)

    push!(p_arr,p_out)
    #plot(surf.x, p_com, layout)
   
    cd("..")

end
#nr_of_traces = size(p_arr, 1) 
#trace_arr = Vector{GenericTrace}(undef, nr_of_traces)

trace_arr = GenericTrace{Dict{Symbol, Any}}[]

for i in p_arr
    trace = scatter(x=x, y=i,
        mode="lines")
    push!(trace_arr,trace)
end

layout = Layout(
            title=attr(text= "Pitching aerofoil at amplitude = 0.5 ", y=0.9, x=0.5, xanchor= "center", yanchor= "top"),
            width = 500, height = 250,
            paper_bgcolor="white",
            xaxis_title = L"x",
            yaxis_title = L"|\Delta P|",
            yaxis_range=[0,0.5]
                )

savePlot = PlotlyJS.plot(trace_arr, layout)
savefig(savePlot,"testPlot_amp_0.5_downwash.html")
cleanWrite()