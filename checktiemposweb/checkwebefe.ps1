Clear-Host

# load the appropriate assemblies 
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")


$URLListFile = "D:\powershell\url\checkstiemposweb\efeList.txt"
#$datosservidores=@{}

$URLList = Get-Content $URLListFile -ErrorAction SilentlyContinue 

#$uri="http://grafica2.madrid.efe.es/efe"

#$uriping="grafica2.madrid.efe.es"
$htmlgraficas="D:\powershell\url\checkstiemposweb\htmlgraficas.html"
"">$htmlgraficas


$pings=@()
$respuestas=@()
$j=0
"<HTML><TITLE>TIEMPOS WEBS EFE</TITLE><BODY><H2> WEBS EFE</H2><Table>" >> $htmlgraficas

Foreach($uri in $URLList) { 



$tiemporespuesta=@()
$tiemporespuestaping=@()
$tiempos=@()
$tiemposping=@()
$t=0
$tping=0



#$htmlgraficas="<HTML><TITLE>TIEMPOS WEBS EFE</TITLE><BODY><H2> WEBS EFE</H2><Table>"


for ($i=0; $i -le 2  ;$i++){

#$Outputreport = "<HTML><TITLE>Website Availability Report</TITLE><BODY background-color:peachpuff><font color =""#99000"" face=""Microsoft Tai le""><H2> Website Availability Report </H2></font><Table border=1 cellpadding=0 cellspacing=0><TR bgcolor=gray align=center><TD><B>URL</B></TD><TD><B>StatusCode</B></TD><TD><B>StatusDescription</B></TD><TD><B>ResponseLength</B></TD><TD><B>TimeTaken</B></TD></TR>"

#$Outputreport += "<TR bgcolor=red>" 

#$Outputreport += "<TD>$($Entry.uri)</TD><TD align=center>$($Entry.StatusCode)</TD><TD align=center>$($Entry.StatusDescription)</TD><TD align=center>$($Entry.ResponseLength)</TD><TD align=center>$($Entry.timetaken)</TD></TR>"

#$Outputreport += "</Table></BODY></HTML>" 

$resultadoping=(Test-Connection $uri -ErrorAction SilentlyContinue |Measure-Object -Property responsetime -Average).Average


$tiemporespuestaping+=$resultadoping
$tiemposping+=$tping
$tping=$tping+5

$resultado = Measure-Command { $request = Invoke-WebRequest -Uri $uri }
#$datosservidores.Add($Uri,$resultado.TotalMilliseconds)
$tiemporespuesta+=($resultado.TotalMilliseconds)
$tiempos+=$t
$t=$t+5


Start-Sleep 2
}

$pings+=,$tiemporespuestaping
$respuestas+=,$tiemporespuesta

#$tiemporespuestaping
#$pings
#$pings[0]


#$datosservidores |fl *


#$tiempos |fl *
#$tiemporespuesta |fl *
#$tiemposping |fl *
#$tiemporespuestaping |fl *



# create chart object 
$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
$Chart.Width = 700
$Chart.Height = 600 
$Chart.Left = 40 
$Chart.Top = 30
#$Chart.Titles[0].Font="segoeuilight,50pt"

# create a chartarea to draw on and add to chart 
$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
$Chart.ChartAreas.Add($ChartArea)

# add data to chart 
[void]$Chart.Series.Add("tiemposervidor") 
#$Chart.Series["tiemposervidor"].Points.DataBindXY($datosservidores.Keys, $datosservidores.Values)
$Chart.Series["tiemposervidor"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$Chart.Series["tiemposervidor"].color="red"
$Chart.Series["tiemposervidor"].Points.DataBindXY($tiempos, $respuestas[$j])


[void]$Chart.Series.Add("tiemposervidorping") 
#$Chart.Series["tiemposervidor"].Points.DataBindXY($datosservidores.Keys, $datosservidores.Values)
$Chart.Series["tiemposervidorping"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$Chart.Series["tiemposervidorping"].color="blue"
$Chart.Series["tiemposervidorping"].Points.DataBindXY($tiemposping, $pings[$j])



# display the chart on a form 
$Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor 
                [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 


# add title and axes labels 
[void]$Chart.Titles.Add($uri) 
$ChartArea.AxisX.Title = "Timeline"
$ChartArea.AxisY.Title = "Tiempo de respuesta:"
$Form = New-Object Windows.Forms.Form 
$Form.Text = "PowerShell Chart" 
$Form.Width = 800 
$Form.Height = 800 
$Form.controls.add($Chart) 
$Form.Add_Shown({$Form.Activate()}) 
#$Form.ShowDialog()
$directorio="D:\powershell\url\checkstiemposweb\"+$uri+".png"
"">directorio
$Chart.SaveImage($directorio,"PNG")
"<TR> <TD> <IMG SRC=$directorio> </TD></TR>" >>$htmlgraficas


$j++
}
"</Table></BODY></HTML>" >> $htmlgraficas
#$htmlgraficas| out-file D:\powershell\url\htmlgraficas.html
