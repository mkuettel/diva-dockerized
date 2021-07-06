#!/usr/bin/env bash
#
# Copyright (C) 2021 diva.exchange
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author/Maintainer: Konrad Bächler <konrad@diva.exchange>
#

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../
cd ${PROJECT_PATH}
PROJECT_PATH=`pwd`/

${PROJECT_PATH}bin/clean.sh

# reasonable defaults
JOIN_NETWORK=${JOIN_NETWORK:-0}
SIZE_NETWORK=${SIZE_NETWORK:-7}
IS_NAME_BASED=${IS_NAME_BASED:-1}
BASE_DOMAIN=${BASE_DOMAIN:-testnet.diva.i2p}
BASE_IP=${BASE_IP:-172.19.72.}
PORT=${PORT:-17468}
HAS_I2P=${HAS_I2P:-0}
I2P_CONSOLE_PORT=${I2P_CONSOLE_PORT:-7070}
NODE_ENV=${NODE_ENV:-production}
LOG_LEVEL=${LOG_LEVEL:-trace}
NETWORK_VERBOSE_LOGGING=${NETWORK_VERBOSE_LOGGING:-0}

if [[ ${HAS_I2P} > 0 ]]
then
  SIZE_NETWORK=${SIZE_NETWORK} \
    BASE_DOMAIN=${BASE_DOMAIN} \
    BASE_IP=${BASE_IP} \
    PORT=${PORT} \
    CREATE_I2P=1 \
    ${PROJECT_PATH}../node_modules/.bin/ts-node ${PROJECT_PATH}main.ts

  sudo docker-compose -f ${PROJECT_PATH}i2p-testnet.yml up -d
  sleep 10
  curl -s http://${BASE_IP}10:${I2P_CONSOLE_PORT}/?page=i2p_tunnels >${PROJECT_PATH}b32/${BASE_DOMAIN}
  sudo docker-compose -f ${PROJECT_PATH}i2p-testnet.yml down
fi

SIZE_NETWORK=${SIZE_NETWORK} \
  IS_NAME_BASED=${IS_NAME_BASED} \
  BASE_DOMAIN=${BASE_DOMAIN} \
  BASE_IP=${BASE_IP} \
  PORT=${PORT} \
  HAS_I2P=${HAS_I2P} \
  NODE_ENV=${NODE_ENV} \
  LOG_LEVEL=${LOG_LEVEL} \
  NETWORK_VERBOSE_LOGGING=${NETWORK_VERBOSE_LOGGING} \
  ${PROJECT_PATH}../node_modules/.bin/ts-node ${PROJECT_PATH}main.ts

chown -R --reference ${PROJECT_PATH} ${PROJECT_PATH}
