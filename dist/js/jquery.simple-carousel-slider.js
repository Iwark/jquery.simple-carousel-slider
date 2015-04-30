/*
 *  jquery.simple-carousel-slider - v1.0.0
 *  Simple jQuery Carousel Slider Plugin
 *  https://github.com/Iwark/jquery.simple-carousel-slider
 *
 *  Made by Iwark <iwark02@gmail.com>
 *  Under MIT License
 */
(function() {
  (function($) {
    var SCSlider, pluginName;
    pluginName = "scSlider";
    $.fn[pluginName] = function(options) {
      return this.each(function() {
        if (!$(this).data(pluginName)) {
          $(this).addClass(pluginName);
          return $(this).data(pluginName, new SCSlider(this, options));
        }
      });
    };
    return SCSlider = (function() {
      var _defaults;

      _defaults = {
        interval: 0,
        draggable: true,
        prev: null,
        next: null
      };

      function SCSlider(source, options) {
        this.source = source;
        this.settings = $.extend({}, _defaults, options);
        this.$slider = $(this.source);
        if (this.settings.prev) {
          this.$prev = $("<div class='sc-prev'><div class='sc-inner'>" + this.settings.prev + "</div></div>");
        }
        if (this.settings.next) {
          this.$next = $("<div class='sc-next'><div class='sc-inner'>" + this.settings.next + "</div></div>");
        }
        this.timer = null;
        this.sliding = false;
        this.dragging = false;
        this.init();
      }

      SCSlider.prototype.init = function() {
        var self;
        self = this;
        this.$slider.find('.sc-slide').filter(':first').addClass('active');
        if (this.settings.interval > 0) {
          this.timer = setInterval(function() {
            return self.slide('left');
          }, this.settings.interval);
        }
        if (this.settings.prev) {
          this.$slider.append(this.$prev);
          this.$prev.on('tap', function() {
            return self.fire('left');
          });
        }
        if (this.settings.next) {
          this.$slider.append(this.$next);
          this.$next.on('tap', function() {
            return self.fire('right');
          });
        }
        if (this.settings.draggable) {
          return this.$slider.on('drag', function(e) {
            if (e.orientation === 'horizontal') {
              self.dragging = true;
              if (1 === e.direction) {
                return self.fire('right');
              } else {
                return self.fire('left');
              }
            }
          });
        }
      };

      SCSlider.prototype.slide = function(dir) {
        var $activeSlide, $nextSlide, leftTo, self;
        if (this.sliding) {
          return;
        }
        this.sliding = true;
        self = this;
        $activeSlide = this.$slider.find('.sc-slide.active');
        leftTo = dir === "left" ? "-100%" : "100%";
        $activeSlide.animate({
          "left": leftTo
        }, function() {
          $activeSlide.removeClass("active");
          if (self.dragging) {
            return setTimeout(function() {
              self.sliding = false;
              return self.dragging = false;
            }, 500);
          } else {
            return self.sliding = false;
          }
        });
        if (dir === 'left') {
          if ($activeSlide.nextAll(".sc-slide").length > 0) {
            $nextSlide = $activeSlide.nextAll(".sc-slide:first");
          } else {
            $nextSlide = $activeSlide.parent().find(".sc-slide").filter(":first");
          }
        } else {
          if ($activeSlide.prevAll(".sc-slide").length > 0) {
            $nextSlide = $activeSlide.prevAll(".sc-slide:first");
          } else {
            $nextSlide = $activeSlide.parent().find(".sc-slide").filter(":last");
          }
        }
        leftTo = dir === "left" ? "100%" : "-100%";
        $nextSlide.css("left", leftTo);
        $nextSlide.addClass("active");
        return $nextSlide.animate({
          "left": 0
        });
      };

      SCSlider.prototype.fire = function(dir) {
        var self;
        self = this;
        this.slide(dir);
        if (this.timer) {
          clearInterval(this.timer);
          return this.timer = setInterval(function() {
            return self.slide('left');
          }, this.settings.interval);
        }
      };

      return SCSlider;

    })();
  })(jQuery);

}).call(this);
