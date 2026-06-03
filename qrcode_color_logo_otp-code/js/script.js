(function () {
    'use strict';

    // ---- DOM refs ----
    const $ = (sel) => document.querySelector(sel);
    const $$ = (sel) => document.querySelectorAll(sel);

    const tabBtns = $$('.tab-btn');
    const tabPanes = $$('.tab-pane');
    const qrData = $('#qr-data');
    const fgColor = $('#fg-color');
    const fgHex = $('#fg-color-hex');
    const bgColor = $('#bg-color');
    const bgHex = $('#bg-color-hex');
    const logoInput = $('#qr-logo');
    const clearLogo = $('#clear-logo');
    const logoPreview = $('#logo-preview');
    const logoPreviewImg = $('#logo-preview-img');
    const logoFilename = $('#logo-filename');
    const qrSize = $('#qr-size');
    const qrSizeValue = $('#qr-size-value');
    const urlShorten = $('#url-shorten');
    const generateBtn = $('#generate-btn');
    const downloadBtn = $('#download-btn');
    const canvas = $('#qr-canvas');
    const placeholder = $('#preview-placeholder');
    const previewArea = $('#preview-area');
    const previewInfo = $('#preview-info');
    const infoType = $('#info-type');
    const infoContent = $('#info-content');
    const infoDimensions = $('#info-dimensions');
    const toastContainer = $('#toast-container');

    const otpType = $('#otp-type');
    const otpIssuer = $('#otp-issuer');
    const otpAccount = $('#otp-account');
    const otpSecret = $('#otp-secret');
    const otpDigits = $('#otp-digits');
    const otpPeriod = $('#otp-period');
    const otpCounter = $('#otp-counter');
    const hotpCounterGroup = $('#hotp-counter-group');
    const genSecret = $('#gen-secret');
    const applyOtp = $('#apply-otp');

    const gpsLat = $('#gps-lat');
    const gpsLng = $('#gps-lng');
    const gpsLabel = $('#gps-label');
    const applyGps = $('#apply-gps');
    const getLocation = $('#get-current-location');

    const atcoCode = $('#atco-code');
    const atcoVehicle = $('#atco-vehicle');
    const atcoDest = $('#atco-destination');
    const atcoLat = $('#atco-lat');
    const atcoLng = $('#atco-lng');
    const atcoTimestamp = $('#atco-timestamp');
    const applyAtco = $('#apply-atco');

    let logoFile = null;

    // ---- Toast ----
    function showToast(msg, type) {
        const el = document.createElement('div');
        el.className = 'toast ' + (type || 'info');
        el.textContent = msg;
        toastContainer.appendChild(el);
        setTimeout(() => { el.style.opacity = '0'; setTimeout(() => el.remove(), 300); }, 2500);
    }

    // ---- Tabs ----
    tabBtns.forEach(btn => {
        btn.addEventListener('click', function () {
            const tab = this.dataset.tab;
            tabBtns.forEach(b => { b.classList.remove('active'); b.setAttribute('aria-selected', 'false'); });
            this.classList.add('active');
            this.setAttribute('aria-selected', 'true');
            tabPanes.forEach(p => p.classList.remove('active'));
            const pane = document.getElementById('tab-' + tab);
            if (pane) pane.classList.add('active');
        });
    });

    // ---- Color sync ----
    function syncColor(input, hexInput) {
        input.addEventListener('input', () => { hexInput.value = input.value.toUpperCase(); });
        hexInput.addEventListener('input', function () {
            let val = this.value.trim();
            if (/^#[0-9a-fA-F]{6}$/.test(val)) { input.value = val; }
        });
    }
    syncColor(fgColor, fgHex);
    syncColor(bgColor, bgHex);

    // ---- Logo ----
    logoInput.addEventListener('change', function () {
        const file = this.files[0];
        if (!file) return;
        logoFile = file;
        const reader = new FileReader();
        reader.onload = function (e) {
            logoPreview.classList.remove('hidden');
            logoPreviewImg.src = e.target.result;
            logoFilename.textContent = file.name;
        };
        reader.readAsDataURL(file);
    });

    clearLogo.addEventListener('click', function () {
        logoInput.value = '';
        logoFile = null;
        logoPreview.classList.add('hidden');
        logoPreviewImg.src = '';
        logoFilename.textContent = '';
    });

    // ---- QR size ----
    qrSize.addEventListener('input', function () {
        qrSizeValue.textContent = this.value + 'px';
    });

    // ---- OTP type toggle ----
    otpType.addEventListener('change', function () {
        hotpCounterGroup.style.display = this.value === 'hotp' ? 'block' : 'none';
    });

    // ---- Generate random secret ----
    genSecret.addEventListener('click', function () {
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
        let secret = '';
        for (let i = 0; i < 32; i++) {
            secret += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        otpSecret.value = secret;
    });

    // ---- Apply OTP ----
    applyOtp.addEventListener('click', function () {
        const issuer = otpIssuer.value.trim();
        const account = otpAccount.value.trim();
        const secret = otpSecret.value.trim().replace(/\s/g, '').toUpperCase();

        if (!issuer || !account || !secret) {
            showToast('Please fill in Issuer, Account Name, and Secret Key', 'error');
            return;
        }

        const type = otpType.value;
        const digits = otpDigits.value;
        const period = otpPeriod.value;
        const encodedIssuer = encodeURIComponent(issuer);
        const encodedAccount = encodeURIComponent(account);

        let url = 'otpauth://' + type + '/' + encodedIssuer + ':' + encodedAccount +
            '?secret=' + secret +
            '&issuer=' + encodedIssuer +
            '&algorithm=SHA1' +
            '&digits=' + digits;

        if (type === 'totp') {
            url += '&period=' + period;
        } else {
            url += '&counter=' + (parseInt(otpCounter.value, 10) || 0);
        }

        qrData.value = url;
        showToast('OTP URL applied! Switch to Basic tab and click Generate.', 'success');
        document.querySelector('.tab-btn[data-tab="basic"]').click();
    });

    // ---- Apply GPS ----
    applyGps.addEventListener('click', function () {
        const lat = parseFloat(gpsLat.value);
        const lng = parseFloat(gpsLng.value);
        if (isNaN(lat) || isNaN(lng)) {
            showToast('Please enter valid latitude and longitude', 'error');
            return;
        }
        const label = gpsLabel.value.trim();
        let url = 'geo:' + lat + ',' + lng;
        if (label) url += '?q=' + encodeURIComponent(label);
        qrData.value = url;
        showToast('GPS data applied! Switch to Basic tab and click Generate.', 'success');
        document.querySelector('.tab-btn[data-tab="basic"]').click();
    });

    // ---- Get current location ----
    getLocation.addEventListener('click', function () {
        if (!navigator.geolocation) {
            showToast('Geolocation is not supported by your browser', 'error');
            return;
        }
        getLocation.disabled = true;
        getLocation.textContent = 'Getting location...';
        navigator.geolocation.getCurrentPosition(
            function (pos) {
                gpsLat.value = pos.coords.latitude.toFixed(6);
                gpsLng.value = pos.coords.longitude.toFixed(6);
                showToast('Location detected!', 'success');
                getLocation.disabled = false;
                getLocation.innerHTML =
                    '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg> Use My Location';
            },
            function (err) {
                showToast('Failed to get location: ' + err.message, 'error');
                getLocation.disabled = false;
                getLocation.innerHTML =
                    '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg> Use My Location';
            },
            { enableHighAccuracy: true, timeout: 10000 }
        );
    });

    // ---- Apply ATCOntime ----
    applyAtco.addEventListener('click', function () {
        const code = atcoCode.value.trim();
        const vehicle = atcoVehicle.value.trim();
        const dest = atcoDest.value.trim();
        const lat = atcoLat.value.trim();
        const lng = atcoLng.value.trim();
        const ts = atcoTimestamp.value;

        if (!code && !vehicle) {
            showToast('Please enter at least ATCO Code or Vehicle ID', 'error');
            return;
        }

        let data = 'ATCO:' + (code || 'N/A');
        data += '|VEHICLE:' + (vehicle || 'N/A');
        data += '|DEST:' + (dest || 'N/A');
        if (lat && lng) data += '|GPS:' + lat + ',' + lng;
        if (ts) data += '|TIME:' + new Date(ts).toISOString();

        qrData.value = data;
        showToast('ATCOntime data applied! Switch to Basic tab and click Generate.', 'success');
        document.querySelector('.tab-btn[data-tab="basic"]').click();
    });

    // ---- Generate QR ----
    generateBtn.addEventListener('click', generateQR);
    qrData.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' && e.ctrlKey) generateQR();
    });

    function generateQR() {
        const text = qrData.value.trim();
        if (!text) {
            showToast('Please enter data to encode', 'error');
            return;
        }

        const size = parseInt(qrSize.value, 10);
        const fg = fgColor.value;
        const bg = bgColor.value;

        try {
            const qr = qrcode(0, 'H');
            qr.addData(text);
            qr.make();

            const moduleCount = qr.getModuleCount();
            const cellSize = Math.floor(size / moduleCount);
            const actualSize = cellSize * moduleCount;

            canvas.width = actualSize;
            canvas.height = actualSize;
            const ctx = canvas.getContext('2d');

            ctx.fillStyle = bg;
            ctx.fillRect(0, 0, actualSize, actualSize);

            ctx.fillStyle = fg;
            for (let row = 0; row < moduleCount; row++) {
                for (let col = 0; col < moduleCount; col++) {
                    if (qr.isDark(row, col)) {
                        ctx.fillRect(col * cellSize, row * cellSize, cellSize, cellSize);
                    }
                }
            }

            // ---- Overlay logo ----
            if (logoFile) {
                const img = new Image();
                const reader = new FileReader();
                reader.onload = function (e) {
                    img.onload = function () {
                        const logoSize = Math.floor(actualSize * 0.25);
                        const logoX = Math.floor((actualSize - logoSize) / 2);
                        const logoY = Math.floor((actualSize - logoSize) / 2);

                        ctx.save();
                        ctx.beginPath();
                        ctx.arc(logoX + logoSize / 2, logoY + logoSize / 2, logoSize / 2 + 4, 0, Math.PI * 2);
                        ctx.fillStyle = bg;
                        ctx.fill();
                        ctx.beginPath();
                        ctx.arc(logoX + logoSize / 2, logoY + logoSize / 2, logoSize / 2, 0, Math.PI * 2);
                        ctx.clip();
                        ctx.drawImage(img, logoX, logoY, logoSize, logoSize);
                        ctx.restore();

                        finish(actualSize, moduleCount, text);
                    };
                    img.src = e.target.result;
                };
                reader.readAsDataURL(logoFile);
            } else {
                finish(actualSize, moduleCount, text);
            }
        } catch (err) {
            showToast('Error generating QR code: ' + err.message, 'error');
            console.error(err);
        }
    }

    function finish(actualSize, moduleCount, text) {
        canvas.classList.remove('hidden');
        placeholder.classList.add('hidden');
        downloadBtn.disabled = false;

        infoType.textContent = detectType(text);
        infoContent.textContent = text.length > 80 ? text.substring(0, 80) + '...' : text;
        infoContent.title = text;
        infoDimensions.textContent = actualSize + 'x' + actualSize + 'px (' + moduleCount + 'x' + moduleCount + ' modules)';
        previewInfo.classList.remove('hidden');

        showToast('QR code generated successfully!', 'success');
    }

    function detectType(text) {
        if (text.startsWith('otpauth://')) return 'OTP Auth';
        if (text.startsWith('geo:')) return 'GPS Location';
        if (text.startsWith('ATCO:')) return 'ATCOntime';
        if (text.startsWith('http://') || text.startsWith('https://')) return 'URL';
        if (text.startsWith('mailto:')) return 'Email';
        if (text.startsWith('tel:')) return 'Phone';
        if (text.startsWith('sms:')) return 'SMS';
        if (text.startsWith('bitcoin:')) return 'Bitcoin';
        if (text.startsWith('wifi:')) return 'WiFi';
        if (text.startsWith('BEGIN:VCARD')) return 'vCard';
        if (text.startsWith('BEGIN:VCALENDAR')) return 'Calendar';
        return 'Plain Text';
    }

    // ---- Download ----
    downloadBtn.addEventListener('click', function () {
        if (!canvas || canvas.width === 0) {
            showToast('Generate a QR code first', 'error');
            return;
        }
        const link = document.createElement('a');
        link.download = 'qrcode.png';
        link.href = canvas.toDataURL('image/png');
        link.click();
        showToast('QR code downloaded!', 'success');
    });

    // ---- Init ----
    const now = new Date();
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
    atcoTimestamp.value = now.toISOString().slice(0, 16);

    console.log('QR Code Color OTP Server ready');
    console.log('Based on: https://github.com/PhDLeToanThang/Web3.0/tree/main/qrcode_color_logo_otp-code');

})();
