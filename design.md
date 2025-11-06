{
  "designSystem": {
    "metadata": {
      "name": "MEMU Play University Management Platform",
      "version": "1.0",
      "platform": "Mobile-First Web Application",
      "designPhilosophy": "Clean, hierarchical interface with blue primary branding and card-based layouts"
    },
    "colorPalette": {
      "primary": {
        "blue": "#1E88E5",
        "darkBlue": "#0D47A1",
        "lightBlue": "#E3F2FD"
      },
      "semantic": {
        "success": "#4CAF50",
        "warning": "#FFC107",
        "error": "#F44336",
        "info": "#2196F3"
      },
      "neutral": {
        "white": "#FFFFFF",
        "lightGray": "#F5F5F5",
        "mediumGray": "#9E9E9E",
        "darkGray": "#424242",
        "charcoal": "#212121"
      }
    },
    "typography": {
      "fontFamily": {
        "primary": "Segoe UI, Roboto, sans-serif",
        "fallback": "Arial, sans-serif"
      },
      "scales": {
        "h1": {
          "fontSize": "24px",
          "fontWeight": "600",
          "lineHeight": "32px",
          "usage": "Page titles, main headers"
        },
        "h2": {
          "fontSize": "18px",
          "fontWeight": "600",
          "lineHeight": "26px",
          "usage": "Section headers, modal titles"
        },
        "h3": {
          "fontSize": "16px",
          "fontWeight": "600",
          "lineHeight": "24px",
          "usage": "Subsection headers, card titles"
        },
        "body": {
          "fontSize": "14px",
          "fontWeight": "400",
          "lineHeight": "20px",
          "usage": "Body text, descriptions"
        },
        "small": {
          "fontSize": "12px",
          "fontWeight": "400",
          "lineHeight": "16px",
          "usage": "Labels, helper text, secondary information"
        },
        "caption": {
          "fontSize": "11px",
          "fontWeight": "400",
          "lineHeight": "14px",
          "usage": "Metadata, timestamps, badges"
        }
      }
    },
    "components": {
      "header": {
        "structure": {
          "layout": "horizontal",
          "height": "56px",
          "backgroundColor": "primary.blue",
          "textColor": "white"
        },
        "elements": {
          "logo": {
            "position": "left",
            "type": "icon + text",
            "size": "32px"
          },
          "title": {
            "position": "center",
            "fontSize": "18px",
            "fontWeight": "600"
          },
          "actionIcons": {
            "position": "right",
            "spacing": "8px",
            "icons": ["menu", "settings", "notifications", "close"]
          }
        }
      },
      "card": {
        "structure": {
          "borderRadius": "8px",
          "backgroundColor": "white",
          "boxShadow": "0 2px 4px rgba(0,0,0,0.1)",
          "padding": "16px",
          "marginBottom": "12px"
        },
        "variants": {
          "elevated": {
            "boxShadow": "0 4px 8px rgba(0,0,0,0.15)"
          },
          "outlined": {
            "border": "1px solid #E0E0E0",
            "boxShadow": "none"
          }
        }
      },
      "button": {
        "structure": {
          "borderRadius": "6px",
          "padding": "10px 16px",
          "fontSize": "14px",
          "fontWeight": "600",
          "border": "none",
          "cursor": "pointer",
          "transition": "all 0.3s ease"
        },
        "variants": {
          "primary": {
            "backgroundColor": "primary.blue",
            "color": "white",
            "hover": {
              "backgroundColor": "darkBlue"
            }
          },
          "secondary": {
            "backgroundColor": "lightGray",
            "color": "charcoal",
            "border": "1px solid #E0E0E0",
            "hover": {
              "backgroundColor": "#EEEEEE"
            }
          },
          "success": {
            "backgroundColor": "semantic.success",
            "color": "white"
          },
          "danger": {
            "backgroundColor": "semantic.error",
            "color": "white"
          }
        }
      },
      "form": {
        "input": {
          "structure": {
            "borderRadius": "4px",
            "border": "1px solid #BDBDBD",
            "padding": "10px 12px",
            "fontSize": "14px",
            "width": "100%",
            "marginBottom": "12px",
            "fontFamily": "primary"
          },
          "states": {
            "focus": {
              "borderColor": "primary.blue",
              "outline": "none",
              "boxShadow": "0 0 0 3px rgba(30, 136, 229, 0.1)"
            },
            "error": {
              "borderColor": "semantic.error",
              "backgroundColor": "#FFEBEE"
            },
            "disabled": {
              "backgroundColor": "lightGray",
              "color": "mediumGray",
              "cursor": "not-allowed"
            }
          }
        },
        "label": {
          "fontSize": "14px",
          "fontWeight": "600",
          "color": "charcoal",
          "marginBottom": "6px",
          "display": "block"
        },
        "helperText": {
          "fontSize": "small",
          "color": "mediumGray",
          "marginTop": "4px"
        }
      },
      "toggle": {
        "structure": {
          "width": "48px",
          "height": "28px",
          "borderRadius": "14px",
          "transition": "all 0.3s ease"
        },
        "states": {
          "on": {
            "backgroundColor": "primary.blue"
          },
          "off": {
            "backgroundColor": "#BDBDBD"
          }
        }
      },
      "badge": {
        "structure": {
          "display": "inline-block",
          "borderRadius": "12px",
          "padding": "4px 12px",
          "fontSize": "caption",
          "fontWeight": "600",
          "textAlign": "center"
        },
        "variants": {
          "success": {
            "backgroundColor": "#C8E6C9",
            "color": "#2E7D32"
          },
          "warning": {
            "backgroundColor": "#FFE0B2",
            "color": "#E65100"
          },
          "error": {
            "backgroundColor": "#FFCDD2",
            "color": "#C62828"
          },
          "info": {
            "backgroundColor": "lightBlue",
            "color": "darkBlue"
          }
        }
      },
      "modal": {
        "structure": {
          "position": "fixed",
          "top": 0,
          "left": 0,
          "width": "100%",
          "height": "100%",
          "backgroundColor": "rgba(0,0,0,0.5)",
          "display": "flex",
          "alignItems": "center",
          "justifyContent": "center",
          "zIndex": 1000
        },
        "content": {
          "backgroundColor": "white",
          "borderRadius": "12px",
          "padding": "24px",
          "maxWidth": "90%",
          "maxHeight": "90vh",
          "overflow": "auto",
          "boxShadow": "0 8px 32px rgba(0,0,0,0.2)"
        }
      },
      "navigationBar": {
        "structure": {
          "position": "bottom",
          "height": "56px",
          "backgroundColor": "white",
          "borderTop": "1px solid #E0E0E0",
          "display": "flex",
          "justifyContent": "space-around",
          "alignItems": "center"
        },
        "navItem": {
          "display": "flex",
          "flexDirection": "column",
          "alignItems": "center",
          "justifyContent": "center",
          "padding": "8px",
          "gap": "4px"
        },
        "icon": {
          "size": "24px",
          "color": "mediumGray"
        },
        "label": {
          "fontSize": "small",
          "color": "mediumGray"
        },
        "activeState": {
          "iconColor": "primary.blue",
          "labelColor": "primary.blue"
        }
      },
      "sidebar": {
        "structure": {
          "width": "280px",
          "backgroundColor": "white",
          "borderRight": "1px solid #E0E0E0",
          "padding": "16px",
          "overflow": "auto"
        },
        "header": {
          "backgroundColor": "primary.blue",
          "color": "white",
          "padding": "16px",
          "borderRadius": "8px",
          "marginBottom": "16px",
          "textAlign": "center"
        },
        "menuItem": {
          "padding": "12px 16px",
          "marginBottom": "8px",
          "borderRadius": "6px",
          "cursor": "pointer",
          "transition": "all 0.2s ease",
          "display": "flex",
          "alignItems": "center",
          "gap": "12px"
        },
        "menuItemActive": {
          "backgroundColor": "lightBlue",
          "color": "primary.blue",
          "fontWeight": "600"
        }
      }
    },
    "layout": {
      "gridSystem": {
        "columns": 12,
        "gutter": "16px",
        "maxWidth": "1200px"
      },
      "spacing": {
        "xs": "4px",
        "sm": "8px",
        "md": "16px",
        "lg": "24px",
        "xl": "32px",
        "xxl": "48px"
      },
      "breakpoints": {
        "mobile": "0px",
        "tablet": "640px",
        "desktop": "1024px",
        "wide": "1440px"
      }
    },
    "patterns": {
      "dashboardLayout": {
        "structure": "header + sidebar + main content",
        "headerHeight": "56px",
        "sidebarWidth": "280px",
        "mainContent": "flexible, scrollable",
        "bottomNav": "persistent on mobile, hidden on desktop"
      },
      "formLayout": {
        "structure": "grouped sections with headers",
        "sectionStyle": "card-based with light gray background",
        "grouping": "related fields grouped under collapsible sections",
        "spacing": "24px between sections"
      },
      "listLayout": {
        "structure": "vertical cards in a column",
        "itemStyle": "card with action buttons",
        "searchBar": "sticky at top",
        "filters": "dropdowns below search"
      },
      "statsDisplay": {
        "structure": "2x2 grid of metric cards",
        "cardStyle": "white background with colored left border or icon",
        "colorCoding": "semantic colors for status",
        "layout": "responsive, stacks on mobile"
      }
    },
    "interactions": {
      "hover": {
        "opacity": 0.9,
        "transition": "0.2s ease"
      },
      "active": {
        "transform": "scale(0.98)",
        "transition": "0.1s ease"
      },
      "focus": {
        "outline": "2px solid primary.blue",
        "outlineOffset": "2px"
      },
      "loading": {
        "animation": "spin 1s linear infinite"
      }
    },
    "accessibility": {
      "contrastRatios": {
        "normalText": "4.5:1 minimum",
        "largeText": "3:1 minimum"
      },
      "focusIndicators": "always visible",
      "semanticHTML": "proper heading hierarchy, form labels, ARIA attributes",
      "ariaLabels": "used for icon buttons and dynamic content"
    },
    "responsive": {
      "mobileFirst": true,
      "breakpointStrategy": "min-width queries",
      "stackedLayout": {
        "mobile": "single column, full width",
        "tablet": "single or two columns depending on content",
        "desktop": "multi-column, fixed widths"
      },
      "hiddenOnMobile": ["sidebar", "detailed descriptions"],
      "expandedOnDesktop": ["sidebar", "additional information panels"]
    },
    "themeVariables": {
      "cssVariables": {
        "--primary-color": "#1E88E5",
        "--primary-dark": "#0D47A1",
        "--primary-light": "#E3F2FD",
        "--success-color": "#4CAF50",
        "--warning-color": "#FFC107",
        "--error-color": "#F44336",
        "--text-primary": "#212121",
        "--text-secondary": "#9E9E9E",
        "--bg-light": "#F5F5F5",
        "--bg-white": "#FFFFFF",
        "--border-color": "#E0E0E0",
        "--shadow-1": "0 2px 4px rgba(0,0,0,0.1)",
        "--shadow-2": "0 4px 8px rgba(0,0,0,0.15)",
        "--transition": "all 0.3s ease"
      }
    }
  }
}