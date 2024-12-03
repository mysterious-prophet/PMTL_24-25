% An example of a more complex calculator solving most of the issues of the
% version from the previous class and adding some new operators and brackets. 
% There might still be some minor problems with the separator dot, but that should be it.

function calculator
    clear; clc; close all
    % Create the calculator window
    h = figure('Units', 'Normalized', 'Position', [0.05 0.5 0.4 0.4], 'Name',...
        'Calculator', 'NumberTitle', 'off', 'MenuBar', 'None', 'Resize', 'off');
    
    % Create calculator display
    disp1 = uicontrol('Units', 'Normalized', 'Style', 'Text', 'Position', ...
        [0.03 0.70 0.77 0.25], 'String', '', 'FontSize', 24, 'FontWeight', 'bold',...
        'BackgroundColor', 'white', 'Tag', 'mmonit', 'HorizontalAlignment'...
        , 'right');
    
    % Buttons
    names = {'7', '8', '9', '+', '%', '.', '4', '5', '6', '-', 'sqrt', '+/-', '1', '2', '3', '*', 'x^2',...
        'C','0', '(',')', '/', '1/x', '='};
    
    % Divide buttons into four rows
    m = 4; n = length(names)/m;
    names1 = {'sev', 'eig', 'nin', 'plu', 'perc', 'dec', 'fou', 'fiv', 'six' , 'sub', 'sqrt', 'sig',...
        'one', 'two', 'thr', 'mul', 'sq', 'back', 'zer', 'lbr', 'rbr', 'div', 'inv', 'equ'};
    
    % Divide buttons into four rows
    wi = 0.13; he = 0.12;
    mw = 0.03; mh = 0.03;
    for i = 1:m
        for j = 1:n
            l1 =  mw + (j-1)*(wi + mw);
            bb = 0.65 - he - (i-1)*(he + mh);
            uicontrol('Parent', h, 'Units', 'Normalized', ...
                'Style', 'pushbutton', 'Position', [l1 bb wi he], 'String', ...
                names{(i-1)*n+j}, 'FontSize', 16, 'FontWeight', 'bold', 'Tag',...
                names1{(i-1)*n+j}, 'Callback', @bigcallback);
        end
    end
    
    % Create CE button
    uicontrol('Units', 'Normalized', 'Style', 'pushbutton', 'Position', ...
        [0.83 0.70 0.13 0.25], 'String', 'CE', 'FontSize', 21, ...
        'FontWeight', 'bold', 'Tag', 'clear', 'Callback', @clear_callback);
    
    % Frame around the display
    hp1 = uipanel(h, 'Units', 'Normalized', 'Position', [0.025 0.69 0.78 0.265]);
    uistack(hp1, 'bottom');
    hp2 = uipanel(h, 'Units', 'Normalized', 'Position', [0 0 1 1]);
    uistack(hp2, 'bottom');
    
    % Total number of operators and decimal points
    % List of possible operators
        signcount = 0;
        dotcount = 0;
        list = ['+', '-', '*', '/'];
        
        function bigcallback(src, ~, ~) 
            switch src.Tag
                case 'sig'
                    % Get the string and count parentheses in it
                    str = get(disp1, 'String');
                    [~, lcount] = size(strfind(str, '('));
                    [~, rcount] = size(strfind(str, ')'));
                    % Evaluation is not possible if the number of parentheses does not match
                    if lcount ~= rcount
                       return; 
                    end
                    % Length of the string
                    n = length(str);
                    % Count operators
                    for i = 2:n
                        if ismember(str(i), list)
                           signcount = signcount + 1; 
                        end
                    end
                    
                    if not(str == "")
                        % If it's just a single number
                        if signcount == 0
                            if str(1) == '-'
                                str = str(2:end);
                            elseif not(str(1) == '-') && not(str == "0")
                                str = insertAfter(str, 0, '-');
                            end
                        end
                        % If it is an expression
                        if signcount > 0 
                            % Auxiliary counts of parentheses to determine whether
                            % we are inside a bracketed subexpression, where
                            % operators remain unchanged
                            lbrcount = lcount;
                            rbrcount = rcount;
                            % Auxiliary variable to indicate whether
                            % the +/- sign should be changed when the subexpression contains
                            % * or /
                            firstmult = false;
                            % Unary +/-
                            for i = 1:n
                                if str(i) == '('
                                    lbrcount = lbrcount - 1;
                                elseif str(i) == ')'
                                    rbrcount = rbrcount - 1;
                                end
                                % If the first operator is * or /, only one sign is changed
                                if (rbrcount == lbrcount) && (str(i) == '*' || str(i) == '/')
                                   firstmult = true;
                                   break;
                                % If the first operator is +/- behave normally
                                elseif (rbrcount == lbrcount) && (str(i) == '-' || str(i) == '+')
                                    firstmult = false;
                                    break;
                                end
                            end
                            % Change unary minus to + (remove the minus)
                            if str(1) == '-'
                                str = str(2:end); 
                            % If it is not a unary minus and not the first multiplication,
                            % add a minus sign
                            elseif not(str(1) == '-')
                                if firstmult == false
                                    str = insertAfter(str, 0, '-');
                                end
                            end
                            % Auxiliary variables help determine if we are
                            % inside brackets, the length of `str`, if it is
                            % a simple bracket (only one number), or if it
                            % involves multiplication or division
                            lbrcount = lcount;
                            rbrcount = rcount;
                            n = length(str);
                            lastpos = 1;                        
                            singlebracket = false;
                            firstmult = false;
                            erasure = false;
                            % Change +/- in the rest of the expression
                            for i = lastpos:n
                                % Avoid exceeding index `n`
                                if not(i > n)
                                    % Determine if we are inside complex or simple brackets.
                                    % Rules do not apply inside complex brackets.
                                    if erasure == true
                                       i = i - 1; 
                                    end
                                    if str(i) == '('
                                        lbrcount = lbrcount - 1;
                                        singlebracket = true;
                                        for k = i + 2:n
                                            if str(k) == ')'
                                                break;
                                            elseif ismember(str(k), list)
                                                singlebracket = false;                                           
                                            end
                                        end
                                    elseif str(i) == ')'
                                        rbrcount = rbrcount - 1;
                                        singlebracket = false;
                                    end
                                    
                                    % Rules for changing signs after * or /
                                    if (i > 1 && str(i-1) == '*' && str(i) == '(' && singlebracket == false && erasure == false && firstmult == false && lcount < 2) || ...
                                       (i > 1 && str(i-1) == '*' && not(str(i) == '-') && firstmult == false && lbrcount == rbrcount)
                                        str = insertAfter(str, i-1, '-');                                        
                                        n = n + 1;
                                        i = i + 1;
                                        firstmult = not(firstmult);
                                        erasure = false;
                                    elseif (i > 1 && str(i-1) == '/' && str(i) == '(' && singlebracket == false && erasure == false && firstmult == false) || ...
                                           (i > 1 && str(i-1) == '/' && not(str(i) == '-') && lbrcount == rbrcount && firstmult == false)
                                        str = insertAfter(str, i-1, '-');                                   
                                        n = n + 1; 
                                        i = i + 1;
                                        firstmult = not(firstmult);
                                    elseif i > 1 && str(i-1) == '*' && str(i) == '-' && lbrcount == rbrcount && firstmult == false
                                        str = eraseBetween(str, i, i);
                                        n = n - 1;
                                        erasure = true;  
                                        firstmult = not(firstmult);
                                    elseif i > 1 && str(i-1) == '/' && str(i) == '-' && lbrcount == rbrcount && firstmult == false
                                        str = eraseBetween(str, i, i);
                                        n = n - 1;
                                        erasure = true; 
                                        firstmult = not(firstmult);
                                    % Change simple +/-
                                    elseif i > 1 && str(i) == '+' && lbrcount == rbrcount
                                        str(i) = '-';   
                                        firstmult = not(firstmult);
                                    elseif i > 1 && str(i) == '-' && lbrcount == rbrcount
                                        str(i) = '+';   
                                        firstmult = not(firstmult);
                                    % Do not change the sign of the argument in sqrt
                                    elseif singlebracket == true && str(i-1) == 't'
                                        singlebracket = false;
                                    % Change the sign inside simple brackets
                                    elseif singlebracket == true && not(str(i+1) == '-')
                                        str = insertAfter(str, i, '-');
                                        n = n + 1;
                                        i = i + 1;
                                        singlebracket = false;
                                    elseif singlebracket == true && str(i+1) == '-'
                                        str = eraseBetween(str, i+1, i+1);
                                        n = n - 1;
                                        singlebracket = false;
                                    end                                    
                                end
                            end
                        end
                    end
                    set(disp1, 'String', str);
                    
                case 'perc'
                    % Percentage: changes the last sub-expression to a percentage
                    str = get(disp1, 'String');
                    [~, lcount] = size(strfind(str, '('));
                    [~, rcount] = size(strfind(str, ')'));
                    for i = 2:n
                        if ismember(str(i), list)
                           signcount = signcount + 1; 
                        end
                    end
                    % Modify if the expression is incomplete, i.e., changing a sub-expression
                    if not(str == "") && not(ismember(str(end), list)) && not(str(end) == '(')
                        if lcount == 0
                            n = length(str);
                            lastsignpos = 0;
                            for i = 1:n
                                if ismember(str(i), list)
                                    lastsignpos = i;
                                end
                            end
                            s = str(lastsignpos+1:end);
                            s = str2double(s);
                            s = s / 100;
                            s = num2str(s);
    
                            str = str(1:lastsignpos);
                            str = insertAfter(str, lastsignpos, s);
                            set(disp1, 'String', str);
                        else
                            rbrcount = 0;
                            lbrcount = 0;
                            for k = n:-1:1
                                if str(k) == ')'
                                    rbrcount = rbrcount + 1;
                                elseif str(k) == '('
                                    lbrcount = lbrcount + 1;
                                end
                                if rbrcount == lbrcount
                                    s = str(k:n);
                                    s = eval(s);
                                    s = s / 100;
                                    s = num2str(s);
                                    str = str(1:k-1);
                                    str = insertAfter(str, k-1, s);
                                    set(disp1, 'String', str);
                                    return;
                                end
                            end
                        end
                    % Change the entire expression
                    elseif signcount > 0 && rcount == lcount
                        str = eval(str);
                        str = str / 100;
                        str = num2str(str);
                        set(disp1, 'String', str);                    
                    end
                    
                case 'sq'
                    % Square: inserts ^2 after the sub-expression
                    str = get(disp1, 'String');
                    n = length(str);
                    % Square complex numbers
                    if (not(str == "") && str(end) == 'i')
                        str = eval(str);
                        str = str^2;
                        set(disp1, 'String', str);
                    elseif not(str == "") && not(ismember(str(end), list))
                        str = insertAfter(str, n, '^2');
                        set(disp1, 'String', str);
                        signcount = 0;
                    end
    
                case 'sqrt'
                    % Square root of an expression
                    str = get(disp1, 'String');
                    n = length(str);
                    for i = 2:n
                        if ismember(str(i), list)
                           signcount = signcount + 1; 
                        end
                    end
                    % If evaluating a single number, compute directly
                    if (signcount == 0 && not(str == ""))
                        str = eval(str);
                        str = sqrt(str);
                        str = num2str(str);
                        set(disp1, 'String', str);
                        signcount = 0;
                    % Cannot insert sqrt unless preceded by an operator or left parenthesis
                    elseif (n > 0 && (not(ismember(str(end), list))) && not(str(end) == '('))
                        return;
                    % Otherwise, insert sqrt( as a sub-expression
                    else
                        str = insertAfter(str, n, 'sqrt(');                    
                        set(disp1, 'String', str);
                        signcount = 0;
                    end
    
                case 'inv'
                    % Inverse (1/x) of an expression
                    str = get(disp1, 'String');
                    n = length(str);
                    lastsignpos = 0;
                    % Find the number of operators and the position of the last operator
                    for i = 2:n
                        if ismember(str(i), list)
                           signcount = signcount + 1;
                           lastsignpos = i;
                        end
                    end
                                    
                    [~, lcount] = size(strfind(str, '('));
                    [~, rcount] = size(strfind(str, ')'));
                    % If it is a sub-expression
                    if not(str == "0") && not(isempty(str)) && not(ismember(str(end), list)) ...
                            && signcount > 0 || dotcount > 0
                        % If there are no parentheses, evaluate only the last number
                        if rcount == 0
                            s = str(lastsignpos+1:end);
                            str = str(1:lastsignpos);
                            s = str2double(s);
                            if s == 0
                               er = 'Division by zero!';
                               set(disp1, 'String', er);
                               pause(2);
                               set(disp1, 'String', "");
                               return;
                            end
                            s = 1 / s;
                            s = num2str(s);
                            str = insertAfter(str, lastsignpos, s);
                            set(disp1, 'String', str);
                            return;
                        % If there are parentheses in the expression, evaluate the nearest closed parenthesis
                        else
                            lbrcount = 0;
                            rbrcount = 0;
                            for k = n:-1:1
                               if str(k) == '('
                                   lbrcount = lbrcount + 1;
                               elseif str(k) == ')'
                                   rbrcount = rbrcount + 1;
                               end
                               if lbrcount == rbrcount
                                    s = str(k:n);
                                    str = str(1:k-1);
                                    s = eval(s);
                                    if s == 0
                                        er = 'Division by zero!';
                                        set(disp1, 'String', er);
                                        pause(2);
                                        set(disp1, 'String', "");
                                        return;
                                    end
                                    s = 1 / s;                                
                                    s = num2str(s);
                                    str = insertAfter(str, k-1, s);
                                    set(disp1, 'String', str);
                                    return;
                               end                                
                            end
                        end
                        str = eval(str);
                        if str == 0                        
                            er = 'Division by zero!';
                            set(disp1, 'String', er);
                            pause(2);
                            set(disp1, 'String', "");
                            return;
                        end
                        str = 1 / str;                    
                        set(disp1, 'String', str);
                    % If it is just zero
                    elseif str == "0"
                        er = 'Division by zero!';                    
                        set(disp1, 'String', er);
                        pause(2);
                        set(disp1, 'String', "");
                    % If it is just a single number
                    elseif not(str == "") && signcount == 0
                        str = eval(str);
                        str = 1 / str;
                        set(disp1, 'String', str);
                    end
                    signcount = 0;
    
                case 'back'
                    % Remove the last character
                    str = get(disp1, 'String');
                    n = length(str);
                    if (str ~= "")
                        % Remove square, square root, operator, or error message
                        if n >= 2 && str(end-1) == '^'
                            str = str(1:end-1);
                        elseif n >= 5 && str(end-4) == 's'
                            str = str(1:end-4);
                        elseif ismember(str(end), list)
                            signcount = signcount - 1;
                        elseif str(end) == '!'
                            set(disp1, 'String', '');
                            return;
                        end
                        % Remove other characters
                        str = str(1:end-1);
                    end
                    set(disp1, 'String', str);
    
                case 'equ'
                    % Equals (=)
                    str = get(disp1, 'String');
                    [~, lcount] = size(strfind(str, '('));
                    [~, rcount] = size(strfind(str, ')'));
                    % Find the number of divisions by zero
                    [~, zerodivcount] = size(strfind(str, '/0'));
                    [~, falsezerodivcount] = size(strfind(str, '/0.'));
                    zerodivcount = zerodivcount - falsezerodivcount;
                    % Evaluate if it is valid
                    if not(str == "") && (zerodivcount == 0) && not(ismember(str(end), list)) && lcount == rcount   
                        str = eval(str);
                        set(disp1, 'String', str);
                        signcount = 0;
                        dotcount = 0;
                    % Do nothing if invalid
                    elseif str == "" || ismember(str(end), list) || lcount ~= rcount
                        set(disp1, 'String', str);
                    % Otherwise, it is division by zero
                    else
                        er = 'Division by zero!';
                        set(disp1, 'String', er);
                        signcount = 0;
                        dotcount = 0;
                        pause(2);
                        set(disp1, 'String', "");
                    end
    
                case 'zer'
                    % Zero
                    str = get(disp1, 'String');
                    n = length(str);
                    % It is not possible to write zero after ( ) ^2    
                    if (n > 1) && (str(end) == '(' || str(end) == ')' || str(end-1) == '^')
                        return;
                    % It is not possible to write two zeros after an operator (allows writing decimals)
                    elseif (n > 1) && (ismember(str(end-1), list)) && (str(end) == '0')
                        return;
                    % It is not possible to write more than one zero at the start (decimals)
                    elseif (n == 1) && str(end) == '0'
                        return;
                    else
                       str = strcat(str, names{strcmp(src.Tag, names1)});
                       set(disp1, 'String', str);
                    end                                                
                otherwise
                    % Number of left and right parentheses in the expression
                    str = get(disp1, 'String');
                    [~, lcount] = size(strfind(str, '('));
                    [~, rcount] = size(strfind(str, ')'));
                    % Length of the string
                    n = length(str);
                    signcount = 0;
    
                    % Special case of writing the first character
                    if str == ""  % First character
                        str = strcat(str, names{strcmp(src.Tag, names1)});
                        % Unary minus
                        if str == "-"
                            set(disp1, 'String', str);
                        % Otherwise, do not allow starting with an operator
                        elseif ismember(str(end), list) || str(end) == ')' || str(end) == '.'
                            str(end) = [];   
                        end
                        set(disp1, 'String', str);
                    % If the number of parentheses matches
                    elseif lcount >= rcount
                        str = strcat(str, names{strcmp(src.Tag, names1)});
                        lastchar = str(end-1);
                        for i = 2:n
                            if ismember(str(i), list)
                                signcount = signcount + 1; 
                            end
                        end
                        % If there are two consecutive operators, replace the second one
                        if (ismember(lastchar, list) && ismember(str(end), list)) 
                            str(end-1) = str(end);
                            str(end) = [];
                        end
    
                        % Number of dots
                        [~, dotcount] = size(strfind(str, '.'));
    
                        % Find the position of the last operator
                        lastsignpos = 0;
                        for i = 1:n
                            if ismember(str(i), list)
                                lastsignpos = i;
                            end
                        end
                        dotcount = signcount; 
    
                        % The dot can only appear once per number
                        for j = lastsignpos+1:n
                            if str(j) == '.'
                                dotcount = dotcount + 1;
                            end
                        end
                        % If there are more dots than numbers, remove the last one
                        if (dotcount >= signcount+1 && str(end) == '.')
                            str = str(1:end-1);
                            set(disp1, 'String', str);
                        end
    
                        % Number of parentheses must match
                        [~, lcount] = size(strfind(str, '('));
                        [~, rcount] = size(strfind(str, ')'));
                        % Parentheses rules: not empty, operators before/after
                        if(rcount > lcount || (str(end-1) == '(') && (str(end) == ')')...
                                || (str(end-1) == '(')  &&  ismember(str(end), list) && not(str(end)=='-')...
                                || (str(end) == '(') && (not(ismember(str(end-1), list))) && not(str(end-1)=='(')...
                                || str(end) == ')' && ismember(str(end-1), list)...
                                || str(end-1) == ')' && (not(ismember(str(end), list))) && not(str(end) ==')'))
                            str = str(1:end-1);
                        end
    
                        set(disp1, 'String', str); 
                        signcount = 0;
                        dotcount = 0;
                    end
            end
        end
    
        % Clear the display
        function clear_callback(varargin)
            set(disp1, 'String', '');
        end
end



