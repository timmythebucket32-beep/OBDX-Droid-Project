
% Timothy Asady-Kany
% Project: BDX Droid (O.B.)
% Last Updated: Oct. 6. 2026

% =======================================================================

% This script creates a GUI to control the robots eyes.
% The GUI shows three buttons: NORMAL, MAD, and OFF.
% NORMAL: Eyes are in a neutral position, and a cute robotic sound plays.
% MAD: Eyes are in a angry position, and a distraught robotic sound plays.
% OFF: Turns the eyes off.

% =======================================================================

clear;
clc;

% ------------------------
% PORT SETTINGS
% ------------------------

SERIAL_PORT = 'COM4';
BAUD_RATE   = 9600;


% ------------------------
% CONNECT TO ARDUINO
% ------------------------

try

    arduino = serialport( ...
        SERIAL_PORT, ...
        BAUD_RATE);

    pause(2);

    flush(arduino);

    disp('Connected to Arduino successfully.');

catch e

    errordlg( ...
        ['Could not open serial port: ' SERIAL_PORT ...
        newline ...
        'Error: ' e.message], ...
        'Connection Error');

    return;

end


% ------------------------
% GUI
% ------------------------

fig = uifigure( ...
    'Name', 'BDX Eye Controller', ...
    'Position', [500 400 500 220], ...
    'Color', [0.15 0.15 0.15]);


% ------------------------
% TITLE
% ------------------------

uilabel(fig, ...
    'Text', 'BDX EYE CONTROL', ...
    'Position', [150 165 200 30], ...
    'FontSize', 18, ...
    'FontWeight', 'bold', ...
    'FontColor', [1 1 1], ...
    'HorizontalAlignment', 'center');


% ------------------------
% STATUS
% ------------------------

statusLabel = uilabel(fig, ...
    'Text', 'Status: NORMAL', ...
    'Position', [150 25 200 25], ...
    'FontSize', 12, ...
    'FontColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'center');


% ------------------------
% NORMAL BUTTON
% ------------------------

btnNormal = uibutton(fig, ...
    'Text', 'NORMAL', ...
    'Position', [30 80 130 60], ...
    'FontSize', 14, ...
    'FontWeight', 'bold', ...
    'BackgroundColor', [0.9 0.9 0.9], ...
    'FontColor', [0.1 0.1 0.1]);


% ------------------------
% MAD BUTTON
% ------------------------

btnMad = uibutton(fig, ...
    'Text', 'MAD', ...
    'Position', [185 80 130 60], ...
    'FontSize', 14, ...
    'FontWeight', 'bold', ...
    'BackgroundColor', [0.8 0.15 0.15], ...
    'FontColor', [1 1 1]);


% ------------------------
% OFF BUTTON
% ------------------------

btnOff = uibutton(fig, ...
    'Text', 'OFF', ...
    'Position', [340 80 130 60], ...
    'FontSize', 14, ...
    'FontWeight', 'bold', ...
    'BackgroundColor', [0.25 0.25 0.25], ...
    'FontColor', [0.8 0.8 0.8]);


% ------------------------
% BUTTON CALLBACKS
% ------------------------

btnNormal.ButtonPushedFcn = @(~,~) ...
    sendCmd( ...
        arduino, ...
        'W', ...
        statusLabel, ...
        btnNormal, ...
        btnMad, ...
        btnOff);


btnMad.ButtonPushedFcn = @(~,~) ...
    sendCmd( ...
        arduino, ...
        'R', ...
        statusLabel, ...
        btnNormal, ...
        btnMad, ...
        btnOff);


btnOff.ButtonPushedFcn = @(~,~) ...
    sendCmd( ...
        arduino, ...
        'O', ...
        statusLabel, ...
        btnNormal, ...
        btnMad, ...
        btnOff);


% Close behavior
fig.CloseRequestFcn = @(~,~) ...
    closeGUI(fig, arduino);


% Initial normal mode
sendCmd( ...
    arduino, ...
    'W', ...
    statusLabel, ...
    btnNormal, ...
    btnMad, ...
    btnOff);



% ------------------------
% SEND COMMAND
% ------------------------

function sendCmd( ...
    arduino, ...
    cmd, ...
    statusLabel, ...
    btnNormal, ...
    btnMad, ...
    btnOff)

    try

        write(arduino, cmd, "char");


        % -------------------------
        % NORMAL
        % -------------------------

        if cmd == 'W'

            statusLabel.Text = ...
                'Status: NORMAL';

            statusLabel.FontColor = ...
                [0.8 0.8 1];

            btnNormal.BackgroundColor = ...
                [1 1 1];

            btnMad.BackgroundColor = ...
                [0.5 0.1 0.1];

            btnOff.BackgroundColor = ...
                [0.2 0.2 0.2];


        % -------------------------
        % MAD
        % -------------------------

        elseif cmd == 'R'

            statusLabel.Text = ...
                'Status: MAD';

            statusLabel.FontColor = ...
                [1 0.4 0.4];

            btnNormal.BackgroundColor = ...
                [0.6 0.6 0.6];

            btnMad.BackgroundColor = ...
                [1 0.15 0.15];

            btnOff.BackgroundColor = ...
                [0.2 0.2 0.2];


        % -------------------------
        % OFF
        % -------------------------

        elseif cmd == 'O'

            statusLabel.Text = ...
                'Status: OFF';

            statusLabel.FontColor = ...
                [0.5 0.5 0.5];

            btnNormal.BackgroundColor = ...
                [0.6 0.6 0.6];

            btnMad.BackgroundColor = ...
                [0.5 0.1 0.1];

            btnOff.BackgroundColor = ...
                [0.4 0.4 0.4];

        end


    catch e

        statusLabel.Text = ...
            ['Error: ' e.message];

        statusLabel.FontColor = ...
            [1 0.5 0];

    end
end



% ------------------------
% CLOSE GUI
% ------------------------

function closeGUI(fig, arduino)

    try

        write(arduino, 'O', "char");

        pause(0.2);

        delete(arduino);

        disp('Serial port closed.');

    catch
    end

    delete(fig);

end