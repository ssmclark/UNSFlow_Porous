push!(LOAD_PATH,"C:/Users/user/ENG_Project_4/UNSFlow_Porous/UnsteadyFlowSolvers.jl/src")

using UnsteadyFlowSolvers, PlotlyJS, LaTeXStrings

cd("C:/Users/user/ENG_Project_4/Plunging_Graphs/")

# each value of scaling parameter 'm'
m = 0:0.25:1

# deletes existing FlowResist folders
folderCheck=isdir("FlowResist_0.0/")
if folderCheck == true
    rm("FlowResist_0.0/", force = true, recursive = true)
    rm("FlowResist_0.5/", force = true, recursive = true)
    rm("FlowResist_0.25/", force = true, recursive = true)
    rm("FlowResist_0.75/", force = true, recursive = true)
    rm("FlowResist_1.0/", force = true, recursive = true)
end

global plungeAmp = 1
global meanVal = 1

x = []
p_arr= []
for j in m 

    mkdir("FlowResist_"*string(j))

    cd("FlowResist_"*string(j))

    alphadef = ConstDef(0.)
    hdef = SinDef(meanVal, plungeAmp, 0.1, 0.)
    udef = ConstDef(1.)

    full_kinem = KinemDef(alphadef, hdef, udef)

    pvt = 0.

    geometry = "FlatPlate"

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

    # for absolute and non absolute values of pressure on y-axis
    #push!(p_arr, p_out)
    push!(p_arr, abs.(p_out))
   
    cd("..")

end

trace_arr = GenericTrace{Dict{Symbol, Any}}[]

for i in p_arr
    trace = scatter(x=x, y=i,
        mode="lines")
    push!(trace_arr,trace)
end

layout = Layout(
            title=attr(text= "Plunging aerofoil at amplitude = $(plungeAmp), mean = $(meanVal)", y=0.9, x=0.5, xanchor= "center", yanchor= "top"),
            width = 600, height = 475,
            xaxis_title = L"x",
            yaxis_title = L"|\Delta P|",
            yaxis_range=[0,1]
                )

savePlot = PlotlyJS.plot(trace_arr, layout)
savefig(savePlot,"plungingAirfoil_amplitude_$(plungeAmp)_mean_$(meanVal).html")
cleanWrite()