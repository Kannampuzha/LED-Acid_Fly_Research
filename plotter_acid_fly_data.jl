using DataFrames, CSV, PlotlyJS,Statistics

# Load the data
df= CSV.read("Plots\\Hostel_Data.csv",DataFrame)

#print(df[:,5])


#Graph 1 , frequecy plot of acid fly attacks
#Make Histogram of columns 4 vs 6
function plot_histogram(df)
    layout=Layout(title="Histogram of columns 4 vs 6",
        xaxis_title="Column 7",
        yaxis_title="Column 5",
        font=attr(family="Times New Roman"),
        legend=attr(font=attr(size=18, family="Times New Roman")),
        xaxis=attr(titlefont=attr(size=18,family="Times New Roman")),
        tickfont=attr(size=18,family="Times New Roman"),
        yaxis=attr(titlefont=attr(size=18,family="Times New Roman")),
        barmode="overlay"
        
        )
    cf=df
    #Remove all coumns except 5th and 7th
    cf=cf[:,[5,7]]
    #only CFL


    #println(cf)
    #Rename the columns as A and B 
    cf=rename(cf,:1=>"Lights",:2=>"Encounters")
    #println(cf)
    
    ans=plot(cf,x=:Encounters,kind="histogram",color=:Lights,xbins=attr(start=1,size=5),Layout(barmode="overlay",font=attr(family="Times New Roman"),
    legend=attr(font=attr(size=18, family="Times New Roman")),xaxis_title="Number of Acid Fly Encounters in Summer 2023",yaxis_title="Number of Rooms Affected"),opacity=0.7)
    savefig(ans,"histogram.pdf",scale=0.5)
end

#Plot 2 - number of people unaffected by acid flies and the lights they use
#plot_histogram(df)
#Count the number of entries which have 7th coulmn as 0
function count_zeros(df)
    count=0
    for i in 1:size(df,1)
        if df[i,7]==0
            count+=1
        end
    end
    println("Number of entries with 0 encounters: $count")
end
#Count Non count_zeros
function count_non_zeros(df)
    count=0
    for i in 1:size(df,1)
        if df[i,7]!=0
            count+=1
        end
    end
    println("Number of entries with non-zero encounters: $count")
end

#count_zeros(df)
#count_non_zeros(df)

#Calculate average of 7th colum groupp by 5th column, new syntax
#remove all rows with 0 encounters

function groupby2(df, col)
    #Remove all rows with 0 encounters
    df=df[df[:,7].!=0,:]
    #Group by the column
    gdf=groupby(df, col)
    return gdf
end

gdf = groupby2(df, :"LED Or CFL" )
#println(gdf)
avg_data=combine(gdf, :"How many times have you been bit or seen the insect?" => mean)
#println(avg_data)

#Plot 3 - Bar graph of average number of acid fly encounters for each type of light
function plot_bar_graph(avg_data)
    

    #Rename
    avg_data=rename(avg_data,:1=>"Light",:2=>"Average")
    println(avg_data)

    ans=plot(avg_data,x=:Light,y=:Average,kind="bar",Layout(font=attr(family="Times New Roman"),legend=attr(font=attr(size=18, family="Times New Roman")),xaxis_title="Type of Light",yaxis_title="Average number of Acid Fly Encounters"))
    #legend=attr(font=attr(size=18, family="Times New Roman")),xaxis_title="Type of Light",yaxis_title="Average number of Acid Fly Attacks"))
    savefig(ans,"bar_graph.pdf",scale=0.5)
end

plot_bar_graph(avg_data)

#Take all non zero data
function non_zero_data(df)
    return df[df[:,7].!=0,:]
end
#Take all zero data
function zero_data(df)
    return df[df[:,7].==0,:]
end

#Data processing for calcualting Probability by bayes theorem
#For the non zero data, calculate how many lights used LEDs, how many used CFLs and how many used both
function count_lights(df)
    #df=non_zero_data(df)
    #println(df)
    count_led=0
    count_cfl=0
    count_both=0
    for i in 1:size(df,1)
        if df[i,5]=="LED"
            count_led+=1
        elseif df[i,5]=="CFL"
            count_cfl+=1
        else
            count_both+=1
        end
    end
    println("Number of people using LED: $count_led")
    println("Number of people using CFL: $count_cfl")
    println("Number of people using both: $count_both")
end


#count_lights(df)



