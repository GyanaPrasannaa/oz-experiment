$ ->

    #coffee --watch --join ./website/js/appDetect.js --compile ./project/develop/coffee/model/LocaleModel.coffee ./project/develop/coffee/utils/Locale.coffee ./project/develop/coffee/utils/BrowserDetection.coffee ./project/develop/coffee/AppDetect.coffee

    window.error = {}
    window.detection = new BrowserDetection 
    window.errorMessage = {}

    window.detection.onSuccess = () =>


        $('#detect').remove()

        $('.qualityCheck').css { 'display':'table' }

        $('.qualityCheck').animate { opacity:1 }, 1000

        # Fix alignment button (Chrome Win / Chrome OSx)
        if navigator.appVersion.indexOf("Win") != -1
            $('.qualityCheck').find('.settings_button').each (index, item) =>
                $(item).css {"padding" : "7px 20px 8px 20px"}

        $('.low_quality').click onLowClick
        $('.high_quality').click onHighClick

    
    window.onQuality = () =>
        script = document.createElement 'script' 
        script.type = 'text/javascript'
        script.src = '/js/r.js'
        $("head").append( script );

    window.onLowClick = =>
        $('.qualityCheck').find('.settings_button').each (index, item) =>
            $(item).css {'cursor' : 'default'}
            $(item).click null

        (window || document).textureQuality = "low"
        (window || document).displayQuality = "med"
        (window || document).dof = false

        $('.qualityCheck').animate {opacity: 0}, 1000, window.onCompleteAnim

    window.onHighClick = =>
        $('.qualityCheck').find('.settings_button').each (index, item) =>
            $(item).css {'cursor' : 'default'}
            $(item).click null
        
        (window || document).textureQuality = "med"
        (window || document).displayQuality = "hi"
        (window || document).dof = true

        $('.qualityCheck').animate {opacity: 0}, 1000, window.onCompleteAnim

    window.onCompleteAnim = =>
        $('.qualityCheck').remove()
        $('#polite').css {'display':'table'}
        onQuality()


    window.detection.onError = ( error ) =>
        window.errorMessage = error
        window.error.locale = new Locale
        window.error.locale.on 'complete', window.fallbackTemplate

    window.fallbackTemplate = ( error )  =>
        $('#detect').css {display : 'table'}
        $('#detect .title').html( window.error.locale.get('homeTitle'))
        $('#detect .errorMessage span').html( window.error.locale.get(window.errorMessage.message))

        for button in window.errorMessage.buttons

            if window.showTechOrTrailer(button)

                c = window.error.locale.get(button+'_url')

                b = $('<a/>')
                b.css {'text-decoration' : 'none'}

                if c == "_!_tryanyway"
                    b.click window.tryAnyway
                else 
                    b.attr
                        href : c
                        target : '_blank'


                b.html "<button class='abstractbutton'>#{window.error.locale.get(button)}</button>"
                $('#detect .btnContainer').append b
                $('#detect .btnContainer').append "<br>"

                # Fix alignment button (Chrome Win / Chrome OSx)
                if navigator.appVersion.indexOf("Win") != -1
                    $(b).css
                        "padding" : "7px 20px 8px 20px"

    window.showTechOrTrailer = (label) =>

        if(label.indexOf('Chrome_NoWebGL_button2') > -1)
            return false

        if(label.indexOf('FF4_noWebGL_button2') > -1)
            return false

        if(label.indexOf('NoWebGLRenderingContext_button2') > -1)
            return false

        if(label.indexOf('NoWebGL_button2') > -1)
            return false

        return true



    window.tryAnyway = (event) =>
        event.preventDefault()
        window.detection.onSuccess()

    img = new Image()
    img.src = '/img/home/interface_1x.png'

    if(window.devicePixelRatio == 2)
        img2 = new Image()
        img2.src = '/img/home/interface_2x.png'
    
    window.detection.init()