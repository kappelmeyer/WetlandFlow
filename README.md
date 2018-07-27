# WetlandFlow

<H2>HYDRAULIC STUDY OF A NON-STEADY HORIZONTAL SUB-SURFACE FLOW CONSTRUCTED WETLAND DURING START-UP</H2>
<H3>https://doi.org/10.1016/j.scitotenv.2018.07.324</H3>

MATLAB Code Description and User Guide

The code was created in MATLAB R2016b and adjusted to run in previous versions (back to MATLAB R2015a)

DESCRIPTION

The sections of code described here were written to accept the data output from a fluorometer (.mv file) and perform the following operations:
<ul>
  <li>read the data</li>
  <li>calibrate the data</li>
  <li>make minor adjustments</li>
  <li>filtering and removing far outlying data </li>
  <li>performing an exponential tail fit to data for which the flow test was terminated early or and the tail was completed manually </li>
  <li>extract the relevant data from the experimental window bounded by the time of tracer injection and the time of fluorometer shut down at the end of the flow test</li>
  <li>calculate the RTD and various hydraulic parameters using two methods: </li>
  <ul>
    <li>standard RTD theory (textbooks by Fogler, Levenspiel etc.) </li>
    <li>modified RTD theory for non-steady flow systems (Werner and Kadled, 1996) </li>
  </ul>
  <li>smake various plots of the hydraulic output </li>
</ul>
The following document details the content and order of execution of the various scripts (.m files and supporting function .m files) <br>


 

NOMENCLATURE <br>

The following section summarizes the naming conventions, content and main function of the files provided as examples: <br>

I File Name I File Name Description I Explanation of content and function I  <br>
