; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;*****************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"


begin
  
  f1 = addfile("swm-tmax-avg-1981-1990.nc","r")
  f2 = addfile("swm-tmax-avg-1991-2000.nc","r")
  f3 = addfile("swm-tmax-avg-2001-2010.nc","r")

  tmaxf1=f1->tasmax
  tmaxf2=f2->tasmax
  tmaxf3=f3->tasmax
 
;***********
; Kelvin to Celcius
;***********
  tmax1=tmaxf1-273.15
  tmax2=tmaxf1-273.15
  tmax3=tmaxf1-273.15
;***********

  lat  = tmaxf1&lat
  lon  = tmaxf1&lon
  nlat = dimsizes(lat)
  nlon = dimsizes(lon)

;------ setting AUTO range with MAX AND MIN values 
; maxval=decimalPlaces(max(val1),0,True)
; minval=decimalPlaces(min(val1),0,True)
;------


;**************************************
;   graph styling
;***************************************
  wks                            = gsn_open_wks("png", "native")        

  res                            = True            	; plot mods desired
  
  res@gsnDraw  			 = False       		; don't draw
  res@gsnFrame 			 = False              	; don't advance frame
  res@cnInfoLabelOn 		 = False              	; turn off cn info label
  res@tmXBLabelsOn         	 = False              	; do not draw bottom labels
  res@tmXBOn              	 = False              	; no bottom tickmarks

  res@gsnMaximize                = True
  res@gsnPaperOrientation        = "Portriat"

  res@sfXArray                   = lon
  res@sfYArray                   = lat



;************This will cause any contours over the ocean to be masked.


  res@mpDataSetName              = "Earth..4"          	; This new database contains
                                                      	; divisions for other countries.
  res@mpDataBaseVersion          = "MediumRes"         	; Medium resolution database

  res@mpOutlineOn                = True                	; Turn on map outlines
  res@mpFillOn                   = True                	; turn on map fill
  res@mpLandFillColor            = "Background"        	; set to white
  res@mpFillDrawOrder            = "PostDraw"


  res@mpFillAreaSpecifiers       = (/"Tamil Nadu","Kerala","Karnataka","Andhra Pradesh"/)
  res@mpSpecifiedFillColors      = (/"transparent","transparent","transparent","transparent"/)
  res@mpOutlineSpecifiers        = (/"Tamil Nadu","Kerala","Karnataka","Andhra Pradesh"/)
  res@mpProvincialLineThicknessF = "2"
  res@mpProvincialLineColor      = "blue"
  res@mpOceanFillColor     	 = "WHITE" 
  res@mpOutlineBoundarySets      = "NoBoundaries"	; eliminate all unneeded boundaries 
  res@mpProjection               = "mercator"       	; projection
  res@mpLimitMode                = "LatLon"         	; method to zoom
  res@mpMinLatF                  = 7.9        
  res@mpMaxLatF             	 = 20.5
  res@mpMinLonF             	 = 73.5
  res@mpMaxLonF            	 = 85.0

;***********

  res@cnFillOn                    = True             	; turn on color 
  res@cnFillMode                  = "AreaFill"       	; fill smoothing within shape
  res@cnLinesOn                   = False            	; no contour lines
  res@cnFillPalette               = "BlGrYeOrReVi200"	; set color map
 
  res@cnLevelSelectionMode        = "ManualLevels"   	; set manual contour levels
  res@cnMinLevelValF              = 23               	; minval           ; set min contour level
  res@cnMaxLevelValF              = 37	            	; maxval           ; set max contour level
  res@cnLevelSpacingF             = 0.5               	; contour spacing
  res@cnInfoLabelOn 		  = False
 
  res@lbLabelBarOn                = False		; turn off label bar
  ;res@lbOrientation               = "vertical"        	; vertical label bar

  ;res@pmTickMarkDisplayMode       = "Always"         	; turn on tickmarks

  res@gsnAddCyclic                = False            	; regional data, should be set to false 
							; used to ensure no gap at GMT

;**************Turn on "fancy" tickmark labels.
  
  res@pmTickMarkDisplayMode	  = "Always"
  res@tmXBLabelsOn                = True		; plot bottom coordinate labels 
  res@tmXBOn              	  = True		; bottom tick marks
  res@tmXBLabelFontColor          = "black"		; Font colour make it invisible for panel
  res@tmXBLabelFontHeightF        = 0.015   		; Make slightly larger
  res@tmYLLabelFontHeightF        = 0.015

;*********

;***********************
;   setting map title
;***********************
   
  ;res@tiMainString                = "Maximum Temperature (~S~o~N~C)"     ; "~S~o~N~C" for degree celcius

;********* 


;******************
;   populate plot maps
;******************

  plot 				 = new(9,graphic)     	; create a plot array  

  plot(0)                        = gsn_csm_contour_map(wks,tmax1(0,:,:),res)

  plot(1)                        = gsn_csm_contour_map(wks,tmax2(0,:,:),res)

  plot(2)                        = gsn_csm_contour_map(wks,tmax3(0,:,:),res)


  ;delete(res@tmXBLabelFontColor)               		; delete the titles

;**********


;************************************************
;    create panel
;************************************************
  resP                   	  = True
  resP@txString          	  = "Decadal max temperature (~S~o~N~C)"
  resP@txFontHeightF     	  = 0.025
  resP@gsnPanelLabelBar    	  = True                	; add common colorbar
  resP@lbLabelFontHeightF  	  = 0.012               	; make labels smaller
  resP@vpWidthF            	  = 0.7                 	; Change width and height 
  resP@vpHeightF          	  = 0.06              		; of labelbar. 
  resP@gsnPanelYWhiteSpacePercent = 5
  resP@gsnPanelXWhiteSpacePercent = 5
  resP@gsnPanelFigureStrings	  = (/"1981-1990","1991-2000","2001-2010"/) ; add strings to panel
  
  resP@gsnPanelFigureStringsFontHeightF = 0.0105
  resP@amJust         			= "TopLeft"
  resP@gsnPanelFigureStringsPerimOn 	= False


;************************
;    plotting
;************************  
  gsn_panel(wks,plot,(/1,3/),resP)

;  plot 				  = gsn_csm_contour_map (wks,oval1(0,:,:),res)    ; create plot

end
