using PlotlyJS
using JSON
using CSV
using DataFrames
#Load the metatadata files
metadata_incandesent=JSON.parsefile("CIE_std_illum_A_1nm.csv_metadata.json")
metadata_fluorescent=JSON.parsefile("CIE_illum_FLs_1nm.csv_metadata.json")
metadata_led=JSON.parsefile("CIE_illum_LEDs_1nm.csv_metadata.json")
metadata_sunlight=JSON.parsefile("CIE_std_illum_D65.csv_metadata.json")

#Range to plot : 380-780 nm

function plot_illuminant(csv_file,name_of_file,sources=[2])
    data_to_plot=csv_file[(csv_file[:,"Wavelength"].>=380) .& (csv_file[:,"Wavelength"].<=400) ,:]
    #println(data_to_plot)
    #Keep font as times new roman, size 18 and bold
    layout=Layout(title="CIE Standard Illuminant $name_of_file",
        xaxis_title="Wavelength (nm)",
        yaxis_title="Spectral Power Distribution(W/m²/nm)",
       
        
        font=attr(family="Times New Roman"),
        legend=attr(font=attr(size=18, family="Times New Roman")),
        xaxis=attr(titlefont=attr(size=18,family="Times New Roman",dtick=20, tick0=380)),
        tickfont=attr(size=18,family="Times New Roman"),
        yaxis=attr(titlefont=attr(size=18,family="Times New Roman")),
        #tickfont=attr(size=18,family="Times New Roman")

        
        )

    #Font  times new roman
    
    #Add figure legend as per sources
    trace=scatter(x=data_to_plot[:,1],y=data_to_plot[:,sources[1]],mode="lines",name=names(data_to_plot)[sources[1]])

    ans=plot(trace,layout)
    columns=names(data_to_plot)
    println(sources)
    
    #Column names of data_to_plot
    for i in sources[2:end]
        println(columns[i])
        t=scatter(x=data_to_plot[:,1],y=data_to_plot[:,i],mode="lines",name=columns[i])
        add_trace!(ans,t)
    end
    savefig(ans,"inset$name_of_file.pdf",scale=0.5)
end
 
incandesent=CSV.read("CIE_std_illum_A_1nm.csv",DataFrame)

plot_illuminant(incandesent,"Incandesent Light")

fluorescent=CSV.read("CIE_illum_FLs_1nm.csv",DataFrame)

plot_illuminant(fluorescent,"Fluorescent Lights",[2,5,7])

led=CSV.read("CIE_illum_LEDs_1nm.csv",DataFrame)

plot_illuminant(led,"LED Lights",[2,3,5,6])

sunlight=CSV.read("CIE_std_illum_D65.csv",DataFrame)

plot_illuminant(sunlight,"Daylight D65")


