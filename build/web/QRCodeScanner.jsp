<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Improved QR Code Scanner</title>
    <script src="https://unpkg.com/@zxing/library@latest"></script>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 20px; }
        #video { width: 100%; max-width: 600px; margin-top: 20px; border: 1px solid #ccc; }
        #message { color: green; margin-top: 20px; font-size: 18px; }
        #error { color: red; margin-top: 10px; font-size: 16px; }
    </style>
</head>
<body>
    <h1>QR Code Scanner</h1>
    <video id="video" autoplay></video>
    <div id="message">Awaiting QR code scan...</div>
    <div id="error"></div>
    <script>
        const codeReader = new ZXing.BrowserQRCodeReader();
        const videoElement = document.getElementById('video');
        const messageElement = document.getElementById('message');
        const errorElement = document.getElementById('error');

        async function startScanner() {
            try {
                // List available devices
                const devices = await codeReader.listVideoInputDevices();
                console.log('Available devices:', devices);

                if (devices.length === 0) {
                    errorElement.textContent = 'No camera found. Please connect a camera.';
                    return;
                }

                // Select the first camera by default
                const selectedDeviceId = devices[0].deviceId;

                // Start scanning
                codeReader.decodeFromVideoDevice(selectedDeviceId, videoElement, (result, err) => {
                    if (result) {
                        const qrData = result.text;
                        console.log('QR Code scanned:', qrData);
                        messageElement.innerHTML = `QR Code Scanned: ${qrData}`;

                        // Send the scanned data to the server
                        fetch('RecordAttendance.jsp', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'qrData=' + encodeURIComponent(qrData)
                        })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                messageElement.innerHTML = `Attendance recorded for Employee ID: ${qrData}`;
                            } else {
                                errorElement.textContent = data.message;
                            }
                        })
                        .catch(err => {
                            errorElement.textContent = 'Error recording attendance.';
                            console.error(err);
                        });
                    } else if (err && !(err instanceof ZXing.NotFoundException)) {
                        errorElement.textContent = 'Error decoding QR Code.';
                        console.error('Decoding error:', err);
                    }
                });
            } catch (error) {
                errorElement.textContent = 'Error accessing camera: ' + error.message;
                console.error('Camera error:', error);
            }
        }

        // Start the scanner when the page loads
        window.onload = startScanner;
    </script>
</body>
</html>

