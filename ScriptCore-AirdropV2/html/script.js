document.addEventListener('DOMContentLoaded', function() {
    let selectedPackage = "illegal_drugs";
    const cards = document.querySelectorAll('.package-card');
    const debugLog = document.getElementById('debug-log');

    
    window.addEventListener('message', function(event) {
        if (event.data.type === "ui") {
            if (event.data.status) {
                document.body.style.display = "flex";
            } else {
                document.body.style.display = "none";
            }
        }
    });


    cards.forEach(card => {
        card.addEventListener('click', function() {
            // Fjern 'active' klasse fra alle og tilføj til den valgte
            cards.forEach(c => c.classList.remove('active'));
            this.classList.add('active');
            
            // Gem den valgte type
            selectedPackage = this.getAttribute('data-type');
        });
    });

    
    document.getElementById('confirm').addEventListener('click', function() {
        const locationIndex = parseInt(document.getElementById('location').value);
        
        const payload = {
            location: locationIndex,
            package: selectedPackage
        };

        // Send data til Lua
        fetch(`https://${GetParentResourceName()}/confirmAirdrop`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        }).catch(err => console.log('Fejl ved fetch:', err));
    });

   
    document.getElementById('close').addEventListener('click', function() {
        fetch(`https://${GetParentResourceName()}/closeMenu`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        }).catch(err => console.log('Fejl ved fetch:', err));
    });

    
    document.onkeyup = function (data) {
        if (data.key === "Escape") {
            fetch(`https://${GetParentResourceName()}/closeMenu`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({})
            });
        }
    };
});