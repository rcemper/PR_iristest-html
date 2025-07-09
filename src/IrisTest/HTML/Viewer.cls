/// HTML viewer for unit test reports
/// You can generate a HTML file by executing the Report class
Class IrisTest.HTML.Viewer Extends %CSP.Page
{

ClassMethod OnPage(pArgs) As %Status
{
	Set id = %request.Get("id")
	Do ..Viewer(id)
	Quit 1
}

ClassMethod Viewer(pUnitTestId As %Integer)
{
	If '$Data(^UnitTest.Result(pUnitTestId),utinfo) {
		Write "<h1> No test result found for id "_pUnitTestId_"</h1>"
		Return 1
	}
	Set utinfo = ^UnitTest.Result(pUnitTestId)
	Set testSuite = $Order(^UnitTest.Result(pUnitTestId,""))
	Set testCase = $Order(^UnitTest.Result(pUnitTestId,testSuite,""))

	Set caseId=pUnitTestId_"||"_testSuite
	Set testCase1 = pUnitTestId_"||"_testSuite_"||"_testCase

	&SQL(Select Status,Duration,Name INTO :status,:Duration,:Name from %UnitTest_Result.TestSuite where TestInstance=:pUnitTestId)

	Set status = $Case(status,0:"failed",1:"passed",:"skipped")
	Write "<!DOCTYPE html>", !
	Write "<html>", !
	Write "  <head>", !
	Write "    <meta charset=""utf-8""/>", !
	Write "    <title id=""head-title"">"_pArgs("reportName")_"</title>", !
	Write "<style>"
	Write "body {font-family: Helvetica, Arial, sans-serif;font-size: 12px;/* do not increase min-width as some may use split screens */min-width: 800px;color: #999;}h1 {font-size: 24px;color: black;}h2 {font-size: 16px;color: black;}p {color: black;}a {color: #999;}table {border-collapse: collapse;}/****************************** * SUMMARY INFORMATION ******************************/#environment td {padding: 5px;border: 1px solid #e6e6e6;vertical-align: top;}#environment tr:nth-child(odd) {background-color: #f6f6f6;}#environment ul {margin: 0;padding: 0 20px;}/****************************** * TEST RESULT COLORS ******************************/span.passed,.passed .col-result {color: green;}span.skipped,span.xfailed,span.rerun,.skipped .col-result,.xfailed .col-result,.rerun .col-result {color: orange;}span.error,span.failed,span.xpassed,.error .col-result,.failed .col-result,.xpassed .col-result {color: red;}.col-links__extra {margin-right: 3px;}/****************************** * RESULTS TABLE * * 1. Table Layout * 2. Extra * 3. Sorting items * ******************************//*------------------ * 1. Table Layout *------------------*/#results-table {border: 1px solid #e6e6e6;color: #999;font-size: 12px;width: 100%;}#results-table th,#results-table td {padding: 5px;border: 1px solid #e6e6e6;text-align: left;}#results-table th {font-weight: bold;}/*------------------ * 2. Extra *------------------*/.logwrapper {max-height: 230px;overflow-y: scroll;background-color: #e6e6e6;}.logwrapper.expanded {max-height: none;}.logwrapper.expanded .logexpander:after {content: ""collapse [-]"";}.logwrapper .logexpander {z-index: 1;position: sticky;top: 10px;width: max-content;border: 1px solid;border-radius: 3px;padding: 5px 7px;margin: 10px 0 10px calc(100% - 80px);cursor: pointer;background-color: #e6e6e6;}.logwrapper .logexpander:after {content: ""expand [+]"";}.logwrapper .logexpander:hover {color: #000;border-color: #000;}.logwrapper .log {min-height: 40px;position: relative;top: -50px;height: calc(100% + 50px);border: 1px solid #e6e6e6;color: black;display: block;font-family: ""Courier New"", Courier, monospace;padding: 5px;padding-right: 80px;white-space: pre-wrap;}div.media {border: 1px solid #e6e6e6;float: right;height: 240px;margin: 0 5px;overflow: hidden;width: 320px;}.media-container {display: grid;grid-template-columns: 25px auto 25px;align-items: center;flex: 1 1;overflow: hidden;height: 200px;}.media-container--fullscreen {grid-template-columns: 0px auto 0px;}.media-container__nav--right,.media-container__nav--left {text-align: center;cursor: pointer;}.media-container__viewport {cursor: pointer;text-align: center;height: inherit;}.media-container__viewport img,.media-container__viewport video {object-fit: cover;width: 100%;max-height: 100%;}.media__name,.media__counter {display: flex;flex-direction: row;justify-content: space-around;flex: 0 0 25px;align-items: center;}.collapsible td:not(.col-links) {cursor: pointer;}.collapsible td:not(.col-links):hover::after {color: #bbb;font-style: italic;cursor: pointer;}.col-result {width: 130px;}.col-result:hover::after {content: "" (hide details)"";}.col-result.collapsed:hover::after {content: "" (show details)"";}#environment-header h2:hover::after {content: "" (hide details)"";color: #bbb;font-style: italic;cursor: pointer;font-size: 12px;}#environment-header.collapsed h2:hover::after {content: "" (show details)"";color: #bbb;font-style: italic;cursor: pointer;font-size: 12px;}/*------------------ * 3. Sorting items *------------------*/.sortable {cursor: pointer;}.sortable.desc:after {content: "" "";position: relative;left: 5px;bottom: -12.5px;border: 10px solid #4caf50;border-bottom: 0;border-left-color: transparent;border-right-color: transparent;}.sortable.asc:after {content: "" "";position: relative;left: 5px;bottom: 12.5px;border: 10px solid #4caf50;border-top: 0;border-left-color: transparent;border-right-color: transparent;}.hidden, .summary__reload__button.hidden {display: none;}.summary__data {flex: 0 0 550px;}.summary__reload {flex: 1 1;display: flex;justify-content: center;}.summary__reload__button {flex: 0 0 300px;display: flex;color: white;font-weight: bold;background-color: #4caf50;text-align: center;justify-content: center;align-items: center;border-radius: 3px;cursor: pointer;}.summary__reload__button:hover {background-color: #46a049;}.summary__spacer {flex: 0 0 550px;}.controls {display: flex;justify-content: space-between;}.filters,.collapse {display: flex;align-items: center;}.filters button,.collapse button {color: #999;border: none;background: none;cursor: pointer;text-decoration: underline;}.filters button:hover,.collapse button:hover {color: #ccc;}.filter__label {margin-right: 10px;}"
	Write "</style>"
	Write "  </head>", !
	Write "  <body>", !
	Write "    <h1 id=""title"">"_pArgs("reportName")_"</h1>", !
	Write "    <p>Report generated on "_$LG(utinfo,1)_" by iris-ut.html</p>", !
	Write "    <div id=""environment-header"">", !
	Write "      <h2>Environment</h2>", !
	Write "    </div>", !
	Write "    <table id=""environment"">", !
	Write "    <!-- TEMPLATES -->", !
	;Write "    <template1 >", !
	;
	Write "      <tr>", !
	Write "        <td>Machine</td>", !
	Write "        <td>"_$LG(utinfo,3)_"</td>", !
	Write "      </tr>", !
	;
	Write "      <tr>", !
	Write "        <td>Instance</td>", !
	Write "        <td>"_$LG(utinfo,4)_"</td>", !
	Write "      </tr>", !
	;
	Write "      <tr>", !
	Write "        <td>version</td>", !
	Write "        <td>"_$LG(utinfo,5)_"</td>", !
	Write "      </tr>", !
	;
	Write "      <tr>", !
	Write "        <td>Namespace</td>", !
	Write "        <td>"_$LG(utinfo,6)_"</td>", !
	Write "      </tr>", !
	Write "</table>"
	; print test suite
	;
	Write "    <div class=""summary"">", !
	Write "      <div class=""summary__data"">", !
	Write "        <h2>Test Suite</h2>", !
	Write "        <div class=""additional-summary prefix"">", !
	Write "        </div>", !
	Write "        <p class=""run-count"">"_Name_" status <span class="""_status_""">"_status_"</span>. tests took "_Duration_" s.</p>", !
	;
	; print testcase
	&SQL(Select Name,Duration,Status,ErrorAction,ErrorDescription INTO
					:Name,:Duration,:Status,:ErrorAction,:ErrorDescription
			 from %UnitTest_Result.TestCase where TestSuite=:caseId)
	Set Status = $Case(Status,0:"failed",1:"passed",:"skipped")
	;
	Write "        <h2>Test case</h2>", !
	Write "    <div class=""summary"">", !
	Write "      <div class=""summary__data"">", !
	;Write "        <h2>Summary</h2>", !
	Write "        <div class=""additional-summary prefix"">", !
	Write "        </div>", !
	Write "        <p class=""run-count"">"_Name_" status <span class="""_Status_""">"_Status_"</span>. tests took "_Duration_" s.</p>", !
	;
	Write "        <p class=""filter"">(Un)check the boxes to filter the results.</p>", !
	;
	; print check box
	&SQL(
		Select   SUM(CASE WHEN Status = 0 THEN 1 ELSE 0 END) AS failed,
		SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END) AS passed,
		SUM(CASE WHEN Status = 2 THEN 1 ELSE 0 END) AS skipped
		INTO :failed,:passed,:skipped
		from %UnitTest_Result.TestMethod where TestCase=:testCase1
	)
	;
	Write "        <div class=""summary__reload"">", !
	Write "          <div class=""summary__reload__button hidden"" onclick=""location.reload()"">", !
	Write "            <div>There are still tests running. <br />Reload this page to get the latest results!</div>", !
	Write "          </div>", !
	Write "        </div>", !
	Write "        <div class=""summary__spacer""></div>", !
	Write "        <div class=""controls"">", !
	Write "          <div class=""filters"">", !
	Write "            <input checked=""true"" class=""filter"" name=""filter_checkbox"" type=""checkbox"" data-test-result=""failed"" />", !
	Write "            <span class=""failed"">"_failed_" Failed,</span>", !
	Write "            <input checked=""true"" class=""filter"" name=""filter_checkbox"" type=""checkbox"" data-test-result=""passed"" />", !
	Write "            <span class=""passed"">"_passed_" Passed,</span>", !
	Write "            <input checked=""true"" class=""filter"" name=""filter_checkbox"" type=""checkbox"" data-test-result=""skipped"" disabled/>", !
	Write "            <span class=""skipped"">"_skipped_" Skipped</span>", !
	Write "          </div>", !
	Write "          <div class=""collapse"">", !
	Write "            <button id=""show_all_details"">Show all details</button>&nbsp;/&nbsp;<button id=""hide_all_details"">Hide all details</button>", !
	Write "          </div>", !
	Write "        </div>", !
	Write "      </div>", !

	;
	Write "      <div class=""additional-summary summary"">", !
	Write "      </div>", !
	Write "      <div class=""additional-summary postfix"">", !
	Write "      </div>", !
	Write "    </div>", !
	;
	; Print test result
	Write "    <table id=""results-table"">", !
	Write "      <thead id=""results-table-head"">", !
	Write "        <tr>", !
	Write "          <th class=""sortable"" data-column-type=""result"">Result</th>", !
	Write "          <th class=""sortable"" data-column-type=""testId"">Test</th>", !
	Write "          <th class=""sortable"" data-column-type=""duration"">Duration</th>", !
	Write "          <th>Links</th>", !
	Write "        </tr>", !
	Write "      </thead>", !
	;
	; print test cases
	Set case=""
	For {
		Set case=$O(^UnitTest.Result(pUnitTestId,testSuite,testCase,case),1,data) q:case=""
		Set status = $Case($LG(data,1),0:"failed",1:"passed",:"skipped")
		Write "<tbody class=""results-table-row "_status_""" id=""testi.py::test_failure"">", !
		Write "<tr class=""collapsible"" data-id=""test_2"">"
		Write "<td class=""col-result collapsed"">"_status_"</td><td class=""col-testId"">"_case_"</td><td class=""col-duration"">"_$LG(data,2)_"</td><td class=""col-links""></td></tr>"
		;
		Set caseDetails = ""
		set data=""
		Write "  <tr class=""extras-row"">", !
			Write "    <td class=""extra"" colspan=""4"">", !
			Write "      <div class=""extraHTML""></div>", !
			Write "      <div class=""media hidden"">", !
			Write "        <div class=""media-container"">", !
			Write "          <div class=""media-container__nav--left"">&lt;</div>", !
			Write "          <div class=""media-container__viewport"">", !
			Write "            <img src="""">", !
			Write "            <video controls="""">", !
			Write "              <source src="""" type=""video/mp4"">", !
			Write "            </video>", !
			Write "          </div>", !
			Write "          <div class=""media-container__nav--right"">&gt;</div>", !
			Write "        </div>", !
			Write "        <div class=""media__name""></div>", !
			Write "        <div class=""media__counter""></div>", !
			Write "      </div>", !
			Write "      <div class=""logwrapper"">", !
			Write "        <div class=""logexpander""></div>", !
			Write "        <div class=""log"">"
		For {
			Set caseDetails=$O(^UnitTest.Result(pUnitTestId,testSuite,testCase,case,caseDetails),1,data) Quit:caseDetails=""
			Write "<span>"_ $TR($LTS($Li(data,2,4)),","," ")_"</span><br>"
		}

		Write "</div>", !
		Write "      </div>", !
		Write "    </td>", !
		Write "  </tr>", !
		Write "</tbody>", !
	}
	; end of print test cases

	Write "    </table>", !
	Write "  </body>", !
	Write "  <footer>", !
	Quit $$$OK
}

}
