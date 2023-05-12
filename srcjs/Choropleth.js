import React, { useState, useEffect } from 'react';
import { BsPauseCircle, BsPlayCircle } from "react-icons/bs";
import { IconContext } from "react-icons";
import { ResponsiveChoropleth } from '@nivo/geo';


function Choropleth(props) {

    const [rotateMap, setRotateMap] = useState(props.rotate_x);
    // const [isActive, setIsActive] = useState(props.interective_rotate); rotate initially
    const [isActive, setIsActive] = useState(props.interective_rotate);
    const [direction, setDirection] = useState('left')

    function toggle() {
      setIsActive(!isActive);
    }


    useEffect(() => {
      let interval = null;
      if (isActive) {
        interval = setInterval(() => {
                setRotateMap(rotateMap => {
                    if(direction === 'left') {
                        if(rotateMap === 360) { setDirection('right') }
                        return(rotateMap + 1)
                    } else {
                        if(rotateMap === -360) { setDirection('left') }
                        return(rotateMap - 1)
                    }
                });
        }, 40);
      } else if (!isActive) {
        clearInterval(interval);
      }
      return () => clearInterval(interval);
    }, [isActive, rotateMap, direction]);
    //   console.log(rotateMap)


    return(
    <div style={{height: props.height}}>
      <IconContext.Provider value={{ color: props.pausePlayBTNcolor, className: "global-class-name" }}>
          <div onClick={toggle}>
              {isActive ? <BsPauseCircle /> : <BsPlayCircle />}
          </div>
      </IconContext.Provider>

      <div
        style={{height: props.height}}
        onMouseEnter={() => setIsActive(false)}
        onMouseLeave={() => setIsActive(true)}
      >
        <ResponsiveChoropleth
            data={props.data}
            features={(props.polygon_json).features}
            margin={{ top: props.margin_top,
                      right: props.margin_right,
                      bottom: props.margin_bottom,
                      left: props.margin_left }}
            //colors={props.polygonColors}
            colors={props.polygonColors}
            domain={[ props.domainMin, props.domainMax ]}
            unknownColor={props.unknownColor}
            label="properties.name"
            valueFormat=".2s"
            projectionType={props.projectionType}
            projectionScale={props.projectionScale}
            projectionTranslation={[ props.projectionTranslation_x, props.projectionTranslation_y ]}
            projectionRotation={[ rotateMap, props.rotate_y, props.rotate_z ]}
            enableGraticule={true}
            graticuleLineColor="#dddddd"
            borderWidth={props.border_width}
            borderColor={props.border_Color}
            tooltip={e => {
                console.log('Tooltip event:')
                console.log(e)
                return (
                    <div
                        style={{
                            background: "#0e1318",
                            padding: "9px 12px",
                            border: "1px solid black",
                            borderRadius: "4px",
                            display: "flex",
                            alignItems: "center",
                            justifyContent: "center",
                            flexDirection: "column",
                            color: "#ffffff",
                        }}
                    >
                        {e.feature.properties.name}:{" "}
                        {e.feature.value
                            ? e.feature.value.toLocaleString()
                            : props.tooltipText}
                    </div>
                );
            }}
            onClick={(data) => {
                console.log(
                     data.id
                );
                // Send data to Shiny with the map_id defined in Shiny
                Shiny.setInputValue(props.map_id, data.id, {priority: "event"});
            }}
            defs={[
              {
                  id: 'gradient',
                  type: 'linearGradient',
                  colors: [
                      {
                          offset: 0,
                          color: '#000'
                      },
                      {
                          offset: 100,
                          color: 'inherit'
                      }
                  ]
              }
          ]}
                  legends={[
            {
                anchor: 'bottom-left',
                direction: 'column',
                justify: true,
                translateX: 20,
                translateY: -100,
                itemsSpacing: 0,
                itemWidth: 94,
                itemHeight: 18,
                itemDirection: 'left-to-right',
                itemTextColor: '#444444',
                itemOpacity: 0.85,
                symbolSize: 18,
                effects: [
                    {
                        on: 'hover',
                        style: {
                            itemTextColor: '#000000',
                            itemOpacity: 1
                        }
                    }
                ]
            }
        ]}


        />
        </div>
    </div>
  )
}

export default Choropleth;

