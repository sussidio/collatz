<%
action = request("a") ''The action
theX = request("n") ''The Number
theM = request("m") ''The Multiplier
maxN = 10000
maxM = 3

''##############################################################
function displayNumberPattern()

    ''Validation
    if theX="" or IsNull(theX) then outErr = "Please enter a number first."
    if theM="" or IsNull(theM) then outErr = "Please enter a multiplier first."
    if outErr="" then
        if cLng(theX)=0 or cLng(theX)>cLng(maxN) then outErr = "Zero time for this number"
        if cLng(theM)=0 or cLng(theM)>cLng(maxM) then outErr = "Zero time for this multiplier"
    end if

    if outErr<>"" then
        response.status = 500
        response.write(outErr)
        response.end
    end if

    output = "0" & vbTab & theX & "<br />"

    for x=0 to maxN
        ''Test for whole number
        theW = theX / 2
        if instr(theW,".") then
            isWhole = false
        else
            isWhole = true
        end if

        ''Apply rule
        if isWhole then
            theX = theX / 2
        else
            theX = theX * theM + 1
        end if

        ''Return seed
        output = output & x+1 & vbTab & theX & "<br />"

        ''Exit loop if equal to 1
        if theX=1 then
            threeX = x+1
            output = output & "Looped " & threeX & " times."
            exit for
        end if
    next

    response.write(output)

end function

''##############################################################
function displayLoops()

    maxS = 0
    maxSNum = 0

    for y=1 to theX

        theX = y

        for x=0 to maxN
            ''Test for whole number
            theW = theX / 2
            if instr(theW,".") then
                isWhole = false
            else
                isWhole = true
            end if

            ''Apply rule
            if isWhole then
                theX = theX / 2
            else
                theX = theX * theM + 1
            end if

            ''Exit loop if equal to 1
            if theX=1 then
                output = output & y & vbTab & x+1 & "<br />"
                exit for
            end if
        next

        if x+1>maxS then
            maxS=x+1
            maxSNum = y
        end if

    next

    output = output & "Max steps was " & maxS & " times for number " & maxSNum & ".<br />"

    response.write(output)

end function

''##############################################################
function default()
    %>
    <html>
        <head>
            <title>Collatz Problem</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.css">
        </head>
        <body>
            <h1>The Collatz Problem</h1>
            <p>The <a href="https://en.wikipedia.org/wiki/Collatz_conjecture">collatz problem</a> or 3x+1 problem has been around for decades and still has not been solved. In the form below enter in your number to check and the multiplier and see if you can crack the code!</p>
            <form name="frmCollatz" id="frmCollatz" method="post" action="?">
                <div>
                    <label>Enter a number</label>
                    <input type="number" name="theX" id="theX" min="1" max="100000" />
                    <p><small>The number should be a positive integer with a maximum value of <%=formatNumber(maxN,0)%>.</small></p>
                </div>
                <div>
                    <label>Enter a multiplier</label>
                    <input type="number" name="theM" id="theM" value="3" min="1" max="3" />
                    <p><small>The multiplier should be a positive integer with a maximum value of <%=maxM%>.</small></p>
                </div>
                <div>
                    <label>Select result output</label>
                    <select name="action" id="action">
                        <option value="display-num-pattern">Number pattern</option>
                        <option value="display-loops">Trajectory steps</option>
                    </select>
                    <p><small>Select the result you would like outputted.</small></p>
                </div>
                <hr />
                <div>
                    <input type="submit" id="btn" value="Calculate" />
                </div>
            </form>
            <div id="result" style="overflow:auto; max-height:500;"></div>

            <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
            <script>
                var maxN = <%=maxN%>;
                var startNum = Math.floor((Math.random() * maxN) + 1);
                $('#theX').val(startNum);

                $("#frmCollatz").submit(function(e){
                    e.preventDefault();
                    var result;
                    var url;

                    //Disable submit
                    $('#btn').prop('disabled', true);

                    //Show wait spinner
                    $("#result").html("<img src='/images/oct07/icons/spinner.gif' />")

                    //Calculate
                    calculate();

                });

                function calculate(){
                    url = '?a=' + $('#action').val() + '&n=' + $('#theX').val() + '&m=' + $('#theM').val();
                    $.post(url, function(data) {
                        result = data;
                    })

                    .done(function (){
                        $("#result").html("<div style='background:#f8f8f8; padding:10px;'>" + result + '</div>');
                        $('#btn').prop('disabled', false);
                    })

                    .fail(function (xhr, textStatus, errorThrown){
					    $("#result").html("<div style='color:white; background:red; padding:10px; border-radius:5px;'>The following error occured: " + xhr.responseText + "</div>");
			 	    })
                }
            </script>
        </body>
    </html>
    <%
end function

select case action
    case "display-num-pattern" : displayNumberPattern()
    case "display-loops" : displayLoops()
    case else: default()
end select

response.flush
%>