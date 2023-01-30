import * as echarts from 'echarts';

function drawGraph(chartDom, data) {
    const myChart = echarts.init(chartDom);
    var option;

    myChart.setOption(
        (option = {
            series: [
                {
                    type: 'tree',
                    data: [data],
                    top: '1%',
                    left: '7%',
                    bottom: '1%',
                    right: '20%',
                    symbolSize: 20,
                    label: {
                        position: 'left',
                        verticalAlign: 'middle',
                        align: 'right',
                        fontSize: 24
                    },
                    leaves: {
                        label: {
                            position: 'right',
                            verticalAlign: 'middle',
                            align: 'left'
                        }
                    },
                    emphasis: {
                        focus: 'descendant'
                    },
                    expandAndCollapse: false,
                    animation: false,
                    animationDuration: 550,
                    animationDurationUpdate: 750
                }
            ]
        })
    );

    option && myChart.setOption(option);

    return myChart;
}

export default drawGraph